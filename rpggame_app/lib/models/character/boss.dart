import '../../core/enums.dart';
import '../../core/constants.dart';
import '../skills/base_skill.dart';
import '../status_effect.dart';
import 'enemy.dart';

class Boss extends Enemy {
  BossPhase phase;
  bool hasTriggeredPhase2;
  final bool hasPhase2;
  final List<BaseSkill> phase2Skills;
  final String introDialogue;
  final String phase2Dialogue;
  final String deathDialogue;
  final String victoryDialogue;

  Boss({
    required super.id,
    required super.name,
    required super.characterClass,
    required super.baseMaxHp,
    required super.baseMaxMp,
    required super.baseMaxSp,
    required super.baseStr,
    required super.baseAgi,
    required super.baseInt,
    required super.baseCon,
    required super.baseDef,
    required super.baseMdef,
    required super.baseCritChance,
    required super.baseCritDamage,
    required super.baseDodgeChance,
    required super.baseAccuracy,
    required super.baseSpeed,
    List<BaseSkill>? skills,
    required super.aiBehavior,
    required super.goldReward,
    required super.xpReward,
    required super.stageArea,
    required super.archetype,
    super.lootTable,
    this.hasPhase2 = false,
    this.phase2Skills = const [],
    required this.introDialogue,
    this.phase2Dialogue = '',
    required this.deathDialogue,
    required this.victoryDialogue,
  })  : phase = BossPhase.phase1,
        hasTriggeredPhase2 = false,
        super(skills: skills);

  // Returns true if phase 2 should trigger (boss hp <= 0 and not yet triggered)
  bool shouldTriggerPhase2() {
    return hasPhase2 && !hasTriggeredPhase2 && currentHp <= 0;
  }

  void enterPhase2() {
    phase = BossPhase.phase2;
    hasTriggeredPhase2 = true;

    final restoreHp = (baseMaxHp * GameConstants.bossPhase2HpPercent).round();
    currentHp = restoreHp;

    // Add phase 2 exclusive skills
    for (final skill in phase2Skills) {
      if (!skills.any((s) => s.id == skill.id)) {
        skills.add(skill);
      }
    }

    // Clear debuffs; rage is purely visual here — damage boost comes from outgoingDamageMultiplier
    activeEffects.removeWhere((e) => e.type != StatusEffectType.rage);
    applyStatusEffect(StatusEffect(
      type: StatusEffectType.rage,
      duration: 999,
      statMultiplier: 1.0,
    ));

    resetAllCooldowns();
  }

  double get outgoingDamageMultiplier =>
      phase == BossPhase.phase2 ? GameConstants.bossPhase2DamageMultiplier : 1.0;

  @override
  Boss clone() => Boss(
        id: id,
        name: name,
        characterClass: characterClass,
        baseMaxHp: baseMaxHp,
        baseMaxMp: baseMaxMp,
        baseMaxSp: baseMaxSp,
        baseStr: baseStr,
        baseAgi: baseAgi,
        baseInt: baseInt,
        baseCon: baseCon,
        baseDef: baseDef,
        baseMdef: baseMdef,
        baseCritChance: baseCritChance,
        baseCritDamage: baseCritDamage,
        baseDodgeChance: baseDodgeChance,
        baseAccuracy: baseAccuracy,
        baseSpeed: baseSpeed,
        skills: List.from(skills),
        aiBehavior: aiBehavior,
        goldReward: goldReward,
        xpReward: xpReward,
        stageArea: stageArea,
        archetype: archetype,
        lootTable: lootTable,
        hasPhase2: hasPhase2,
        phase2Skills: phase2Skills,
        introDialogue: introDialogue,
        phase2Dialogue: phase2Dialogue,
        deathDialogue: deathDialogue,
        victoryDialogue: victoryDialogue,
      );

  String get currentDialogue {
    if (phase == BossPhase.phase2 && phase2Dialogue.isNotEmpty) {
      return phase2Dialogue;
    }
    return introDialogue;
  }
}
