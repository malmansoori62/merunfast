import '../core/enums.dart';
import '../models/character/hero.dart';
import 'skills_data.dart';

class HeroesData {
  HeroesData._();

  static Hero brix() => Hero(
        id: 'hero_brix',
        name: 'Brix',
        characterClass: CharacterClass.warrior,
        baseMaxHp: 180,
        baseMaxMp: 40,
        baseMaxSp: 120,
        baseStr: 22,
        baseAgi: 10,
        baseInt: 6,
        baseCon: 20,
        baseDef: 16,
        baseMdef: 8,
        baseCritChance: 0.08,
        baseCritDamage: 1.75,
        baseDodgeChance: 0.04,
        baseAccuracy: 0.92,
        baseSpeed: 10,
        skills: [
          SkillsData.crushingBlow(),
          SkillsData.shieldWall(),
          SkillsData.berserkerRage(),
          SkillsData.ironSkin(),
        ],
      );

  static Hero lyra() => Hero(
        id: 'hero_lyra',
        name: 'Lyra',
        characterClass: CharacterClass.rogue,
        baseMaxHp: 130,
        baseMaxMp: 60,
        baseMaxSp: 140,
        baseStr: 14,
        baseAgi: 24,
        baseInt: 10,
        baseCon: 12,
        baseDef: 10,
        baseMdef: 10,
        baseCritChance: 0.18,
        baseCritDamage: 2.10,
        baseDodgeChance: 0.16,
        baseAccuracy: 0.94,
        baseSpeed: 16,
        skills: [
          SkillsData.backstab(),
          SkillsData.poisonDaggers(),
          SkillsData.shadowstep(),
          SkillsData.shadowMastery(),
        ],
      );

  static Hero kaelen() => Hero(
        id: 'hero_kaelen',
        name: 'Kaelen',
        characterClass: CharacterClass.mage,
        baseMaxHp: 100,
        baseMaxMp: 160,
        baseMaxSp: 80,
        baseStr: 8,
        baseAgi: 12,
        baseInt: 28,
        baseCon: 10,
        baseDef: 6,
        baseMdef: 18,
        baseCritChance: 0.12,
        baseCritDamage: 1.90,
        baseDodgeChance: 0.08,
        baseAccuracy: 0.96,
        baseSpeed: 13,
        skills: [
          SkillsData.fireball(),
          SkillsData.arcaneBurst(),
          SkillsData.manaShield(),
          SkillsData.arcaneMind(),
        ],
      );

  // All heroes in selection order
  static List<Hero> all() => [brix(), lyra(), kaelen()];

  static Hero byId(String id) {
    switch (id) {
      case 'hero_brix': return brix();
      case 'hero_lyra': return lyra();
      case 'hero_kaelen': return kaelen();
      default: return brix();
    }
  }

  // Skills available to unlock on level up
  static final Map<String, List<String>> levelUpSkills = {
    'hero_brix': ['ground_slam'],
    'hero_lyra': ['blade_dance'],
    'hero_kaelen': ['frost_nova'],
  };

  static String classDescription(CharacterClass cls) {
    switch (cls) {
      case CharacterClass.warrior:
        return 'A hardened warrior forged in the mines of Ironhold. '
            'High HP and armor make Brix nearly unstoppable on the front lines. '
            'Excels at absorbing punishment and controlling fights with brute force.';
      case CharacterClass.rogue:
        return 'A shadow-dancer from the slums, Lyra strikes before her enemies '
            'can react. Extreme critical hits and evasion make her the deadliest '
            'duelist in the colosseum — if she can stay alive.';
      case CharacterClass.mage:
        return 'A forbidden-arts scholar banished to the arena, Kaelen channels '
            'raw arcane power into devastating spells. Lowest HP of the three, '
            'but the highest burst damage and magical dominance.';
    }
  }
}
