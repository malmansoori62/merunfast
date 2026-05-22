import 'dart:math';
import '../core/enums.dart';
import '../core/constants.dart';
import '../core/game_events.dart';
import '../models/character/base_character.dart';
import '../models/character/hero.dart';
import '../models/character/enemy.dart';
import '../models/character/boss.dart';
import '../models/skills/base_skill.dart';
import '../models/skills/magic_skill.dart';
import '../models/skills/physical_skill.dart';
import '../models/items/consumable.dart';
import '../managers/loot_manager.dart';

class CombatManager {
  final Random _rng = Random();

  CombatState _state = CombatState.initializing;
  Hero? _hero;
  List<Enemy> _enemies = [];
  List<BaseCharacter> _turnOrder = [];
  int _turnIndex = 0;
  int _roundNumber = 0;

  final List<CombatLogEntry> combatLog = [];
  BattleResult? lastResult;
  bool _phase2Triggered = false;

  CombatState get state => _state;
  Hero? get hero => _hero;
  List<Enemy> get enemies => List.unmodifiable(_enemies);
  bool get isPlayerTurn => _state == CombatState.playerTurn;
  bool get isOver =>
      _state == CombatState.victory ||
      _state == CombatState.defeat ||
      _state == CombatState.escaped;
  int get round => _roundNumber;

  BaseCharacter? get currentActor =>
      _turnIndex < _turnOrder.length ? _turnOrder[_turnIndex] : null;

  // ── Battle initialization ─────────────────────────────────────────────────

  void initBattle(Hero hero, List<Enemy> enemies) {
    _hero = hero;
    _enemies = enemies.map((e) => e.clone()).toList();
    _state = CombatState.initializing;
    _turnIndex = 0;
    _roundNumber = 1;
    _phase2Triggered = false;
    combatLog.clear();
    lastResult = null;

    hero.stopDefending();
    hero.resetAllCooldowns();
    for (final e in _enemies) e.resetAllCooldowns();

    _buildTurnOrder();
    _log('⚔️  Battle begins! Round $_roundNumber.', LogType.system);
    _advanceToNextTurn();
  }

  void _buildTurnOrder() {
    final all = <BaseCharacter>[_hero!, ..._enemies];
    all.sort((a, b) {
      final diff = b.agi.compareTo(a.agi);
      return diff != 0 ? diff : (_rng.nextBool() ? 1 : -1);
    });
    _turnOrder = all;
  }

  // ── Player actions ────────────────────────────────────────────────────────

  void playerAttack() {
    if (!isPlayerTurn) return;
    _state = CombatState.processingAction;
    final hero = _hero!;
    hero.stopDefending();
    hero.useSp(10);

    final target = _pickEnemyTarget();
    if (target == null) { _checkBattleEnd(); return; }

    final dmgResult = _calcPhysicalDamage(hero, target, 1.0);
    _applyDamageResult(dmgResult, target);
    _log(dmgResult.toLogEntry().message, dmgResult.isCritical ? LogType.combat : LogType.combat);

    _afterPlayerAction();
  }

  void playerUseSkill(int skillIndex) {
    if (!isPlayerTurn) return;
    final hero = _hero!;
    if (skillIndex >= hero.skills.length) return;

    final skill = hero.skills[skillIndex];
    final useResult = SkillUseResult(
      casterName: hero.name,
      skillName: skill.name,
      success: skill.canUse(
        currentMana: hero.currentMp,
        currentStamina: hero.currentSp,
        isSilenced: hero.isSilenced,
        isExhausted: hero.isExhausted,
      ),
      failReason: _skillFailReason(skill, hero),
    );

    _log(useResult.toLogEntry().message, useResult.success ? LogType.combat : LogType.system);
    if (!useResult.success) return;

    _state = CombatState.processingAction;
    hero.stopDefending();
    hero.useMp(skill.manaCost);
    hero.useSp(skill.staminaCost);
    skill.triggerCooldown();

    final isSelf = skill is MagicSkill && skill.isSelfTarget;
    if (isSelf) {
      for (final fx in skill.onHitEffects) {
        if (_rng.nextDouble() <= fx.applyChance) {
          hero.applyStatusEffect(fx.buildEffect());
          _log('${hero.name} gained ${fx.type.name}!', LogType.status);
        }
      }
    } else {
      final Enemy? singleTarget = _pickEnemyTarget();
      final targets = skill.isAreaDamage
          ? _enemies.where((e) => e.isAlive).toList()
          : (singleTarget != null ? [singleTarget] : <Enemy>[]);
      for (final target in targets) {
        if (!target.isAlive) continue;
        if (skill.damageMultiplier > 0) {
          final dmg = _calcSkillDamage(hero, target, skill);
          _applyDamageResult(dmg, target);
          _log(dmg.toLogEntry().message, LogType.combat);
          if (!dmg.isDodged) _applySkillEffects(skill, hero, target);
        } else {
          _applySkillEffects(skill, hero, target);
        }
      }
    }

    _afterPlayerAction();
  }

  void playerDefend() {
    if (!isPlayerTurn) return;
    _state = CombatState.processingAction;
    _hero!.startDefending();
    _log('${_hero!.name} takes a defensive stance. SP restored.', LogType.combat);
    _afterPlayerAction();
  }

  void playerUseItem(Consumable item) {
    if (!isPlayerTurn) return;
    _state = CombatState.processingAction;
    _applyConsumable(_hero!, item);
    _afterPlayerAction();
  }

  bool playerEscape() {
    if (!isPlayerTurn) return false;
    _state = CombatState.processingAction;
    final chance = GameConstants.escapeBaseChance +
        (_hero!.agi - (_enemies.isNotEmpty ? _enemies.first.agi : 0)) * 0.01;
    final success = _rng.nextDouble() <= chance.clamp(0.1, 0.85);
    if (success) {
      _log('${_hero!.name} escapes from battle!', LogType.system);
      _state = CombatState.escaped;
    } else {
      _log('${_hero!.name} failed to escape!', LogType.system);
      _afterPlayerAction();
    }
    return success;
  }

  // ── Enemy AI turn ─────────────────────────────────────────────────────────

  void processEnemyTurn() {
    if (_state != CombatState.enemyTurn) return;
    _state = CombatState.processingAction;

    final enemy = currentActor as Enemy?;
    if (enemy == null || !enemy.isAlive) {
      _advanceToNextTurn();
      return;
    }

    enemy.stopDefending();

    // Check if enemy skips turn (stun/freeze)
    if (!enemy.canTakeTurn) {
      _log('${enemy.name} is ${_getSkipReason(enemy)} and skips their turn!', LogType.status);
      _afterEnemyAction(enemy);
      return;
    }

    // AI decision
    if (enemy.shouldDefend) {
      enemy.startDefending();
      _log('${enemy.name} braces defensively.', LogType.combat);
      _afterEnemyAction(enemy);
      return;
    }

    final skillIdx = enemy.selectSkillIndex();
    if (skillIdx >= 0) {
      final skill = enemy.skills[skillIdx];
      enemy.useMp(skill.manaCost);
      enemy.useSp(skill.staminaCost);
      skill.triggerCooldown();
      _log('${enemy.name} used ${skill.name}!', LogType.combat);

      if (skill.damageMultiplier > 0 || skill.onHitEffects.isNotEmpty) {
        final dmg = _calcSkillDamage(enemy, _hero!, skill);
        if (skill.damageMultiplier > 0) {
          _applyDamageResult(dmg, _hero!);
          _log(dmg.toLogEntry().message, LogType.combat);
        }
        if (!dmg.isDodged) _applySkillEffects(skill, enemy, _hero!);
      }
    } else {
      // Basic attack
      enemy.useSp(10);
      final dmg = _calcPhysicalDamage(enemy, _hero!, 1.0);
      _applyDamageResult(dmg, _hero!);
      _log(dmg.toLogEntry().message, LogType.combat);
    }

    _afterEnemyAction(enemy);
  }

  // ── Damage calculation ────────────────────────────────────────────────────

  DamageResult _calcPhysicalDamage(
      BaseCharacter attacker, BaseCharacter defender, double multiplier) {
    double rawDmg = attacker.str * multiplier;
    if (attacker is Boss) rawDmg *= attacker.outgoingDamageMultiplier;
    return _finalizeDamage(attacker, defender, rawDmg.round(), DamageType.physical, false);
  }

  DamageResult _calcSkillDamage(
      BaseCharacter caster, BaseCharacter target, BaseSkill skill) {
    double raw;
    bool ignoresDef = false;

    if (skill is MagicSkill) {
      raw = caster.intelligence * skill.damageMultiplier;
      ignoresDef = skill.ignoresDefense;
    } else if (skill is PhysicalSkill && skill.usesAgi) {
      raw = caster.agi * skill.damageMultiplier;
    } else {
      raw = caster.str * skill.damageMultiplier;
    }

    // Boss phase 2 damage multiplier
    if (caster is Boss) raw *= caster.outgoingDamageMultiplier;

    return _finalizeDamage(caster, target, raw.round(),
        skill is MagicSkill ? DamageType.magical : DamageType.physical,
        ignoresDef);
  }

  DamageResult _finalizeDamage(
      BaseCharacter attacker, BaseCharacter defender, int rawDamage,
      DamageType type, bool ignoresDefense) {
    // Dodge check
    final dodgeRoll = _rng.nextDouble();
    if (dodgeRoll < defender.dodgeChance) {
      return DamageResult(
        rawDamage: rawDamage, finalDamage: 0,
        isCritical: false, isDodged: true,
        damageType: type,
        attackerName: attacker.name, defenderName: defender.name,
      );
    }

    // Defense reduction
    int defense = ignoresDefense ? 0 : (type == DamageType.physical ? defender.def : defender.mdef);
    if (defender.isDefending) {
      defense = (defense * (1 + GameConstants.defendTempDefenseBonus)).round();
    }

    int dmg = (rawDamage - defense).clamp(GameConstants.minDamage.round(), 99999);

    // Weakness debuff
    if (attacker.hasEffect(StatusEffectType.weakness)) {
      dmg = (dmg * 0.70).round().clamp(1, 99999);
    }

    // Defender defending damage reduction
    if (defender.isDefending) {
      dmg = (dmg * (1 - GameConstants.defendDamageReduction)).round().clamp(1, 99999);
    }

    // Exhausted attacker
    if (attacker.isExhausted && type == DamageType.physical) {
      dmg = (dmg * (1 - GameConstants.exhaustionDamagePenalty)).round().clamp(1, 99999);
    }

    // Critical hit
    final critRoll = _rng.nextDouble();
    bool isCrit = critRoll < attacker.critChance;
    if (isCrit) {
      dmg = (dmg * attacker.critDamage).round();
    }

    return DamageResult(
      rawDamage: rawDamage, finalDamage: dmg,
      isCritical: isCrit, isDodged: false,
      damageType: type,
      attackerName: attacker.name, defenderName: defender.name,
    );
  }

  void _applyDamageResult(DamageResult result, BaseCharacter target) {
    if (result.isDodged) return;
    target.takeDamage(result.finalDamage);

    // Check boss phase 2 BEFORE checking alive
    if (target is Boss && target.shouldTriggerPhase2() && !_phase2Triggered) {
      _phase2Triggered = true;
      target.enterPhase2();
      _log('💀 ${target.name} ENTERS PHASE 2! They revive with ${target.currentHp} HP!', LogType.story);
      _log(target.phase2Dialogue, LogType.story);
    }
  }

  // ── Status effects ────────────────────────────────────────────────────────

  void _applySkillEffects(BaseSkill skill, BaseCharacter caster, BaseCharacter target) {
    if (skill is MagicSkill && skill.isSelfTarget) return; // self-target handled separately
    for (final fx in skill.onHitEffects) {
      if (_rng.nextDouble() <= fx.applyChance) {
        target.applyStatusEffect(fx.buildEffect());
        _log('${target.name} is now ${fx.type.name}!', LogType.status);
      }
    }
  }

  // ── Turn management ───────────────────────────────────────────────────────

  void _afterPlayerAction() {
    if (isOver) return;
    _removeDeadEnemies();
    if (_checkBattleEnd()) return;
    _hero!.tickSkillCooldowns();
    _advanceToNextTurn();
  }

  void _afterEnemyAction(Enemy enemy) {
    if (isOver) return;
    if (!_hero!.isAlive) { _resolveBattleEnd(); return; }
    enemy.tickSkillCooldowns();
    enemy.regenSp();
    _advanceToNextTurn();
  }

  void _advanceToNextTurn() {
    _turnIndex = (_turnIndex + 1) % _turnOrder.length;

    // Skip dead characters
    int safetyCounter = 0;
    while (_turnIndex < _turnOrder.length &&
        !_turnOrder[_turnIndex].isAlive &&
        safetyCounter < _turnOrder.length) {
      _turnIndex = (_turnIndex + 1) % _turnOrder.length;
      safetyCounter++;
    }

    // New round
    if (_turnIndex == 0) {
      _roundNumber++;
      _log('── Round $_roundNumber ──', LogType.system);
      _processAllStatusEffects();
    }

    final actor = _turnOrder[_turnIndex];
    if (!_checkBattleEnd()) {
      if (actor is Hero) {
        actor.regenSp();
        _state = CombatState.playerTurn;
      } else {
        _state = CombatState.enemyTurn;
      }
    }
  }

  void _processAllStatusEffects() {
    _state = CombatState.applyingEffects;
    for (final char in _turnOrder) {
      if (!char.isAlive) continue;
      final msgs = char.processStatusEffects();
      for (final msg in msgs) _log(msg, LogType.status);
    }
    _removeDeadEnemies();
  }

  // ── Battle end ────────────────────────────────────────────────────────────

  bool _checkBattleEnd() {
    if (!_hero!.isAlive) { _resolveBattleEnd(); return true; }
    final allDead = _enemies.every((e) => !e.isAlive);
    if (allDead) { _resolveBattleEnd(); return true; }
    return false;
  }

  void _resolveBattleEnd() {
    if (!_hero!.isAlive) {
      _state = CombatState.defeat;
      _log('💀 ${_hero!.name} has fallen.', LogType.story);
    } else {
      _state = CombatState.victory;
      _log('🏆 Victory! All enemies defeated!', LogType.story);
    }
  }

  void _removeDeadEnemies() {
    for (final e in _enemies.where((e) => !e.isAlive && e is! Boss)) {
      if (!e.isAlive) {
        _log('${e.name} is defeated!', LogType.combat);
      }
    }
  }

  // ── Consumable application ────────────────────────────────────────────────

  void _applyConsumable(Hero hero, Consumable item) {
    switch (item.effect) {
      case ConsumableEffect.restoreHp:
        final amount = item.effectPercent > 0
            ? (hero.maxHp * item.effectPercent).round()
            : item.effectAmount;
        hero.heal(amount);
        _log('${hero.name} restored $amount HP.', LogType.combat);
      case ConsumableEffect.restoreMp:
        final amount = item.effectPercent > 0
            ? (hero.maxMp * item.effectPercent).round()
            : item.effectAmount;
        hero.restoreMp(amount);
        _log('${hero.name} restored $amount MP.', LogType.combat);
      case ConsumableEffect.restoreSp:
        hero.restoreSp(item.effectAmount);
        _log('${hero.name} restored ${item.effectAmount} SP.', LogType.combat);
      case ConsumableEffect.revive:
        if (!hero.isAlive) {
          hero.currentHp = (hero.maxHp * item.effectPercent).round().clamp(1, hero.maxHp);
          _log('${hero.name} was revived with ${hero.currentHp} HP!', LogType.system);
        }
      case ConsumableEffect.fullRestore:
        hero.heal(hero.maxHp);
        hero.restoreMp(hero.maxMp);
        hero.restoreSp(hero.maxSp);
        _log('${hero.name} fully restored!', LogType.system);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Enemy? _pickEnemyTarget() {
    final alive = _enemies.where((e) => e.isAlive).toList();
    if (alive.isEmpty) return null;
    // Target weakest enemy for tactical play
    alive.sort((a, b) => a.currentHp.compareTo(b.currentHp));
    return alive.first;
  }

  String? _skillFailReason(BaseSkill skill, Hero hero) {
    if (skill.isOnCooldown) return '(${skill.currentCooldown} turns CD remaining)';
    if (skill.manaCost > hero.currentMp) return '(not enough MP)';
    if (skill.staminaCost > hero.currentSp) return '(not enough SP)';
    if (hero.isSilenced && skill.type == SkillType.magic) return '(silenced)';
    if (hero.isExhausted && skill.type == SkillType.physical) return '(exhausted)';
    return null;
  }

  String _getSkipReason(BaseCharacter c) {
    if (c.isStunned) return 'stunned';
    if (c.isFrozen) return 'frozen';
    return 'unable to act';
  }

  void _log(String message, LogType type) {
    combatLog.add(CombatLogEntry(message: message, type: type));
  }

  LootResult generateLoot(StageArea area) {
    final lootMgr = LootManager();
    return lootMgr.generateLoot(_enemies, area);
  }

  void reset() {
    _hero = null;
    _enemies = [];
    _turnOrder = [];
    _turnIndex = 0;
    _roundNumber = 0;
    _state = CombatState.initializing;
    combatLog.clear();
    lastResult = null;
    _phase2Triggered = false;
  }
}
