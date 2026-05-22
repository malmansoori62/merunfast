import '../../core/enums.dart';
import '../../core/constants.dart';
import '../status_effect.dart';
import '../skills/base_skill.dart';
import '../skills/passive_skill.dart';
import '../items/equipment.dart';

abstract class BaseCharacter {
  final String id;
  String name;
  final CharacterClass characterClass;

  // Base stats (before equipment)
  int baseMaxHp;
  int baseMaxMp;
  int baseMaxSp;
  int baseStr;
  int baseAgi;
  int baseInt;
  int baseCon;
  int baseDef;
  int baseMdef;
  double baseCritChance;
  double baseCritDamage;
  double baseDodgeChance;
  double baseAccuracy;
  int baseSpeed;

  // Current resource values
  int currentHp;
  int currentMp;
  int currentSp;

  // Combat flags
  bool isDefending = false;

  // Skills
  final List<BaseSkill> skills;

  // Status effects
  final List<StatusEffect> activeEffects = [];

  // Equipment bonuses (applied by InventoryManager)
  Map<String, int> equipmentBonuses = {
    'str': 0, 'agi': 0, 'int': 0, 'con': 0,
    'def': 0, 'mdef': 0, 'hp': 0, 'mp': 0,
  };
  double equipmentCritBonus = 0.0;
  double equipmentDodgeBonus = 0.0;

  BaseCharacter({
    required this.id,
    required this.name,
    required this.characterClass,
    required this.baseMaxHp,
    required this.baseMaxMp,
    required this.baseMaxSp,
    required this.baseStr,
    required this.baseAgi,
    required this.baseInt,
    required this.baseCon,
    required this.baseDef,
    required this.baseMdef,
    required this.baseCritChance,
    required this.baseCritDamage,
    required this.baseDodgeChance,
    required this.baseAccuracy,
    required this.baseSpeed,
    List<BaseSkill>? skills,
  })  : currentHp = baseMaxHp,
        currentMp = baseMaxMp,
        currentSp = baseMaxSp,
        skills = skills ?? [];

  // ── Effective stats (base + equipment + passives + effects) ──────────────

  int get maxHp => baseMaxHp + (equipmentBonuses['hp'] ?? 0) + _passiveBonus('hp');
  int get maxMp => baseMaxMp + (equipmentBonuses['mp'] ?? 0) + _passiveBonus('mp');
  int get maxSp => baseMaxSp;

  int get str => _applyStatMultiplier(baseStr + (equipmentBonuses['str'] ?? 0) + _passiveBonus('str'));
  int get agi => _applyStatMultiplier(baseAgi + (equipmentBonuses['agi'] ?? 0) + _passiveBonus('agi'));
  int get intelligence =>
      _applyStatMultiplier(baseInt + (equipmentBonuses['int'] ?? 0) + _passiveBonus('int'));
  int get con => _applyStatMultiplier(baseCon + (equipmentBonuses['con'] ?? 0) + _passiveBonus('con'));
  int get def => _applyStatMultiplier(baseDef + (equipmentBonuses['def'] ?? 0) + _passiveBonus('def') +
      (isDefending ? (baseDef * GameConstants.defendTempDefenseBonus).round() : 0));
  int get mdef =>
      _applyStatMultiplier(baseMdef + (equipmentBonuses['mdef'] ?? 0) + _passiveBonus('mdef'));

  double get critChance => baseCritChance + equipmentCritBonus + _passiveCritBonus;
  double get critDamage => baseCritDamage;
  double get dodgeChance => baseDodgeChance + equipmentDodgeBonus + _passiveDodgeBonus;

  int _passiveBonus(String stat) {
    int bonus = 0;
    for (final s in skills) {
      if (s is PassiveSkill) {
        switch (stat) {
          case 'str': bonus += s.strBonus; break;
          case 'agi': bonus += s.agiBonus; break;
          case 'int': bonus += s.intBonus; break;
          case 'def': bonus += s.defBonus; break;
          case 'mdef': bonus += s.mdefBonus; break;
          case 'hp': bonus += s.hpBonus; break;
          case 'mp': bonus += s.mpBonus; break;
        }
      }
    }
    return bonus;
  }

  double get _passiveCritBonus {
    double bonus = 0.0;
    for (final s in skills) {
      if (s is PassiveSkill) bonus += s.critChanceBonus;
    }
    return bonus;
  }

  double get _passiveDodgeBonus {
    double bonus = 0.0;
    for (final s in skills) {
      if (s is PassiveSkill) bonus += s.dodgeBonus;
    }
    return bonus;
  }

  int _applyStatMultiplier(int base) {
    double mult = 1.0;
    for (final fx in activeEffects) {
      if (fx.type == StatusEffectType.weakness ||
          fx.type == StatusEffectType.rage ||
          fx.type == StatusEffectType.exhaustion) {
        mult *= fx.statMultiplier;
      }
    }
    return (base * mult).round().clamp(1, 9999);
  }

  // ── State checks ──────────────────────────────────────────────────────────

  bool get isAlive => currentHp > 0;
  bool get isExhausted => currentSp <= 0 || hasEffect(StatusEffectType.exhaustion);
  bool get isSilenced => hasEffect(StatusEffectType.silence);
  bool get isStunned => hasEffect(StatusEffectType.stun);
  bool get isFrozen => hasEffect(StatusEffectType.freeze);
  bool get canTakeTurn => !isStunned && !isFrozen;

  bool hasEffect(StatusEffectType type) =>
      activeEffects.any((e) => e.type == type);

  StatusEffect? getEffect(StatusEffectType type) {
    try {
      return activeEffects.firstWhere((e) => e.type == type);
    } catch (_) {
      return null;
    }
  }

  // ── Resource management ───────────────────────────────────────────────────

  void takeDamage(int amount) {
    // Check for shield first
    int remaining = amount;
    final shield = getEffect(StatusEffectType.shield);
    if (shield != null) {
      remaining = shield.absorbDamage(amount);
      if (shield.isExpired) activeEffects.remove(shield);
    }
    currentHp = (currentHp - remaining).clamp(0, maxHp);
  }

  void heal(int amount) {
    currentHp = (currentHp + amount).clamp(0, maxHp);
  }

  void useMp(int amount) {
    currentMp = (currentMp - amount).clamp(0, maxMp);
  }

  void restoreMp(int amount) {
    currentMp = (currentMp + amount).clamp(0, maxMp);
  }

  void useSp(int amount) {
    currentSp = (currentSp - amount).clamp(0, maxSp);
    if (currentSp <= 0 && !hasEffect(StatusEffectType.exhaustion)) {
      applyStatusEffect(StatusEffect.exhaustion());
    }
  }

  void regenSp() {
    if (isExhausted && hasEffect(StatusEffectType.exhaustion)) return;
    currentSp = (currentSp + GameConstants.spRegenPerTurn).clamp(0, maxSp);
  }

  void restoreSp(int amount) {
    currentSp = (currentSp + amount).clamp(0, maxSp);
    if (currentSp > 0) {
      activeEffects.removeWhere((e) => e.type == StatusEffectType.exhaustion);
    }
  }

  // ── Status effects ────────────────────────────────────────────────────────

  void applyStatusEffect(StatusEffect effect) {
    final existing = getEffect(effect.type);
    if (existing != null) {
      existing.tryAddStack();
    } else {
      activeEffects.add(effect);
    }
  }

  List<String> processStatusEffects() {
    final messages = <String>[];
    final toRemove = <StatusEffect>[];

    for (final fx in activeEffects) {
      if (fx.isDoT) {
        final dmg = fx.getTickDamage();
        takeDamage(dmg);
        messages.add('$name takes $dmg ${fx.displayName} damage.');
      }
      fx.tick();
      if (fx.isExpired) toRemove.add(fx);
    }

    for (final fx in toRemove) {
      activeEffects.remove(fx);
      messages.add('$name recovered from ${fx.displayName}.');
    }

    // Check SP recovery if exhaustion expired
    if (!hasEffect(StatusEffectType.exhaustion) && currentSp <= 0) {
      currentSp = (maxSp * 0.15).round();
    }

    return messages;
  }

  void clearAllEffects() => activeEffects.clear();

  // ── Defend action ─────────────────────────────────────────────────────────

  void startDefending() {
    isDefending = true;
    final spRestore = (maxSp * GameConstants.defendSpRestorePercent).round();
    restoreSp(spRestore);
  }

  void stopDefending() => isDefending = false;

  // ── Skill cooldowns ───────────────────────────────────────────────────────

  void tickSkillCooldowns() {
    for (final s in skills) s.tickCooldown();
  }

  void resetAllCooldowns() {
    for (final s in skills) s.resetCooldown();
  }

  // ── Equipment bonuses ─────────────────────────────────────────────────────

  void applyEquipmentBonuses(List<Equipment?> equipped) {
    equipmentBonuses = {'str': 0, 'agi': 0, 'int': 0, 'con': 0,
                        'def': 0, 'mdef': 0, 'hp': 0, 'mp': 0};
    equipmentCritBonus = 0.0;
    equipmentDodgeBonus = 0.0;
    for (final eq in equipped) {
      if (eq == null) continue;
      equipmentBonuses['str'] = (equipmentBonuses['str'] ?? 0) + eq.strBonus;
      equipmentBonuses['agi'] = (equipmentBonuses['agi'] ?? 0) + eq.agiBonus;
      equipmentBonuses['int'] = (equipmentBonuses['int'] ?? 0) + eq.intBonus;
      equipmentBonuses['con'] = (equipmentBonuses['con'] ?? 0) + eq.conBonus;
      equipmentBonuses['def'] = (equipmentBonuses['def'] ?? 0) + eq.defBonus;
      equipmentBonuses['mdef'] = (equipmentBonuses['mdef'] ?? 0) + eq.mdefBonus;
      equipmentBonuses['hp'] = (equipmentBonuses['hp'] ?? 0) + eq.hpBonus;
      equipmentBonuses['mp'] = (equipmentBonuses['mp'] ?? 0) + eq.mpBonus;
      equipmentCritBonus += eq.critBonus;
      equipmentDodgeBonus += eq.dodgeBonus;
    }
  }

  void fullRestore() {
    currentHp = maxHp;
    currentMp = maxMp;
    currentSp = maxSp;
    activeEffects.clear();
    isDefending = false;
    resetAllCooldowns();
  }
}
