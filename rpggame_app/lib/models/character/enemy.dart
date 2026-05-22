import '../../core/enums.dart';
import '../skills/base_skill.dart';
import 'base_character.dart';

class LootEntry {
  final String itemId;
  final double dropChance;
  const LootEntry({required this.itemId, required this.dropChance});
}

class Enemy extends BaseCharacter {
  final AIBehavior aiBehavior;
  final int goldReward;
  final int xpReward;
  final List<LootEntry> lootTable;
  final StageArea stageArea;
  final String archetype;

  Enemy({
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
    required this.aiBehavior,
    required this.goldReward,
    required this.xpReward,
    required this.stageArea,
    required this.archetype,
    this.lootTable = const [],
  }) : super(skills: skills);

  bool get shouldDefend => aiBehavior == AIBehavior.defensive && _hpPercent < 0.30;
  bool get isEnraged => aiBehavior == AIBehavior.berserker && _hpPercent < 0.50;
  double get _hpPercent => maxHp > 0 ? currentHp / maxHp : 0;

  // ── AI decision logic ─────────────────────────────────────────────────────

  int selectSkillIndex() {
    final usableSkills = skills
        .asMap()
        .entries
        .where((e) => e.value.canUse(
              currentMana: currentMp,
              currentStamina: currentSp,
              isSilenced: isSilenced,
              isExhausted: isExhausted,
            ))
        .toList();

    if (usableSkills.isEmpty) return -1;

    switch (aiBehavior) {
      case AIBehavior.aggressive:
        // Pick highest damage multiplier
        usableSkills.sort(
            (a, b) => b.value.damageMultiplier.compareTo(a.value.damageMultiplier));
        return usableSkills.first.key;

      case AIBehavior.berserker:
        // Always use strongest attack, ignore costs if enraged
        usableSkills.sort(
            (a, b) => b.value.damageMultiplier.compareTo(a.value.damageMultiplier));
        return usableSkills.first.key;

      case AIBehavior.tactical:
        // Alternate between skills
        final idx = usableSkills[
            (DateTime.now().millisecondsSinceEpoch % usableSkills.length)];
        return idx.key;

      case AIBehavior.defensive:
        // Use defensive/healing skills when available
        return usableSkills.first.key;

      case AIBehavior.support:
        return usableSkills.first.key;
    }
  }

  Enemy clone() => Enemy(
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
      );
}
