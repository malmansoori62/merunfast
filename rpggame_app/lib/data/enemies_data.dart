import '../core/enums.dart';
import '../models/character/enemy.dart';
import '../models/character/boss.dart';
import 'skills_data.dart';

class EnemiesData {
  EnemiesData._();

  // ── Stage 1: Ironhold Mines ───────────────────────────────────────────────

  static Enemy mineGladiator() => Enemy(
        id: 'mine_gladiator',
        name: 'Mine Gladiator',
        characterClass: CharacterClass.warrior,
        baseMaxHp: 80, baseMaxMp: 20, baseMaxSp: 80,
        baseStr: 14, baseAgi: 8, baseInt: 4, baseCon: 12,
        baseDef: 8, baseMdef: 4,
        baseCritChance: 0.06, baseCritDamage: 1.5,
        baseDodgeChance: 0.04, baseAccuracy: 0.88,
        baseSpeed: 8,
        skills: [SkillsData.heavySlash()],
        aiBehavior: AIBehavior.aggressive,
        goldReward: 18, xpReward: 45,
        stageArea: StageArea.ironholdMines,
        archetype: 'Gladiator',
        lootTable: [LootEntry(itemId: 'iron_sword', dropChance: 0.20)],
      );

  static Enemy cageWolf() => Enemy(
        id: 'cage_wolf',
        name: 'Cage Wolf',
        characterClass: CharacterClass.rogue,
        baseMaxHp: 65, baseMaxMp: 10, baseMaxSp: 100,
        baseStr: 12, baseAgi: 18, baseInt: 4, baseCon: 8,
        baseDef: 4, baseMdef: 4,
        baseCritChance: 0.14, baseCritDamage: 1.8,
        baseDodgeChance: 0.18, baseAccuracy: 0.90,
        baseSpeed: 18,
        skills: [SkillsData.savageBite()],
        aiBehavior: AIBehavior.aggressive,
        goldReward: 14, xpReward: 38,
        stageArea: StageArea.ironholdMines,
        archetype: 'Beast',
        lootTable: [LootEntry(itemId: 'wolf_pelt', dropChance: 0.30)],
      );

  static Enemy shackledMage() => Enemy(
        id: 'shackled_mage',
        name: 'Shackled Mage',
        characterClass: CharacterClass.mage,
        baseMaxHp: 55, baseMaxMp: 90, baseMaxSp: 50,
        baseStr: 6, baseAgi: 10, baseInt: 18, baseCon: 8,
        baseDef: 4, baseMdef: 12,
        baseCritChance: 0.10, baseCritDamage: 1.6,
        baseDodgeChance: 0.06, baseAccuracy: 0.93,
        baseSpeed: 12,
        skills: [SkillsData.darkBlast(), SkillsData.curseWeakness()],
        aiBehavior: AIBehavior.tactical,
        goldReward: 22, xpReward: 52,
        stageArea: StageArea.ironholdMines,
        archetype: 'Mage',
        lootTable: [LootEntry(itemId: 'arcane_tome', dropChance: 0.15)],
      );

  // ── Stage 2: Red Sand Colosseum ───────────────────────────────────────────

  static Enemy arenaAssassin() => Enemy(
        id: 'arena_assassin',
        name: 'Arena Assassin',
        characterClass: CharacterClass.rogue,
        baseMaxHp: 110, baseMaxMp: 40, baseMaxSp: 130,
        baseStr: 16, baseAgi: 26, baseInt: 8, baseCon: 12,
        baseDef: 8, baseMdef: 8,
        baseCritChance: 0.20, baseCritDamage: 2.0,
        baseDodgeChance: 0.18, baseAccuracy: 0.94,
        baseSpeed: 22,
        skills: [SkillsData.backstab(), SkillsData.poisonDaggers()],
        aiBehavior: AIBehavior.tactical,
        goldReward: 40, xpReward: 90,
        stageArea: StageArea.redSandColosseum,
        archetype: 'Assassin',
        lootTable: [LootEntry(itemId: 'shadow_blade', dropChance: 0.18)],
      );

  static Enemy colossumTank() => Enemy(
        id: 'colossum_tank',
        name: 'Iron Bulwark',
        characterClass: CharacterClass.warrior,
        baseMaxHp: 160, baseMaxMp: 20, baseMaxSp: 100,
        baseStr: 20, baseAgi: 6, baseInt: 4, baseCon: 22,
        baseDef: 20, baseMdef: 8,
        baseCritChance: 0.04, baseCritDamage: 1.5,
        baseDodgeChance: 0.02, baseAccuracy: 0.85,
        baseSpeed: 6,
        skills: [SkillsData.heavySlash(), SkillsData.shieldWall()],
        aiBehavior: AIBehavior.defensive,
        goldReward: 48, xpReward: 95,
        stageArea: StageArea.redSandColosseum,
        archetype: 'Tank',
        lootTable: [LootEntry(itemId: 'tower_shield', dropChance: 0.20)],
      );

  static Enemy berserker() => Enemy(
        id: 'colosseum_berserker',
        name: 'Blood Berserker',
        characterClass: CharacterClass.warrior,
        baseMaxHp: 130, baseMaxMp: 30, baseMaxSp: 110,
        baseStr: 26, baseAgi: 14, baseInt: 4, baseCon: 16,
        baseDef: 10, baseMdef: 6,
        baseCritChance: 0.16, baseCritDamage: 1.9,
        baseDodgeChance: 0.06, baseAccuracy: 0.88,
        baseSpeed: 14,
        skills: [SkillsData.crushingBlow(), SkillsData.berserkerRage()],
        aiBehavior: AIBehavior.berserker,
        goldReward: 44, xpReward: 92,
        stageArea: StageArea.redSandColosseum,
        archetype: 'Berserker',
        lootTable: [LootEntry(itemId: 'fury_axe', dropChance: 0.16)],
      );

  // ── Stage 3: Imperial Shadow Arena ───────────────────────────────────────

  static Enemy shadowNecromancer() => Enemy(
        id: 'shadow_necromancer',
        name: 'Shadow Necromancer',
        characterClass: CharacterClass.mage,
        baseMaxHp: 160, baseMaxMp: 180, baseMaxSp: 60,
        baseStr: 10, baseAgi: 14, baseInt: 34, baseCon: 14,
        baseDef: 8, baseMdef: 24,
        baseCritChance: 0.14, baseCritDamage: 1.85,
        baseDodgeChance: 0.08, baseAccuracy: 0.95,
        baseSpeed: 14,
        skills: [SkillsData.darkBlast(), SkillsData.curseWeakness(), SkillsData.shadowCurse()],
        aiBehavior: AIBehavior.tactical,
        goldReward: 75, xpReward: 170,
        stageArea: StageArea.imperialShadowArena,
        archetype: 'Necromancer',
        lootTable: [LootEntry(itemId: 'void_staff', dropChance: 0.22)],
      );

  static Enemy imperialGuard() => Enemy(
        id: 'imperial_guard',
        name: 'Imperial Guard',
        characterClass: CharacterClass.warrior,
        baseMaxHp: 200, baseMaxMp: 40, baseMaxSp: 120,
        baseStr: 28, baseAgi: 12, baseInt: 6, baseCon: 26,
        baseDef: 26, baseMdef: 14,
        baseCritChance: 0.10, baseCritDamage: 1.65,
        baseDodgeChance: 0.04, baseAccuracy: 0.90,
        baseSpeed: 10,
        skills: [SkillsData.heavySlash(), SkillsData.commanderCharge()],
        aiBehavior: AIBehavior.aggressive,
        goldReward: 80, xpReward: 175,
        stageArea: StageArea.imperialShadowArena,
        archetype: 'Gladiator',
        lootTable: [LootEntry(itemId: 'imperial_plate', dropChance: 0.18)],
      );

  // ── Boss: Overseer Sark ───────────────────────────────────────────────────

  static Boss overseerSark() => Boss(
        id: 'boss_sark',
        name: 'Overseer Sark',
        characterClass: CharacterClass.warrior,
        baseMaxHp: 320, baseMaxMp: 60, baseMaxSp: 140,
        baseStr: 28, baseAgi: 12, baseInt: 8, baseCon: 28,
        baseDef: 18, baseMdef: 10,
        baseCritChance: 0.12, baseCritDamage: 1.80,
        baseDodgeChance: 0.06, baseAccuracy: 0.90,
        baseSpeed: 12,
        skills: [SkillsData.heavySlash(), SkillsData.overseerWhip(), SkillsData.groundSlam()],
        aiBehavior: AIBehavior.aggressive,
        goldReward: 120, xpReward: 250,
        stageArea: StageArea.ironholdMines,
        archetype: 'Gladiator',
        hasPhase2: false,
        introDialogue: 'You dare defy me?! I\'ve broken a thousand gladiators — you are nothing!',
        deathDialogue: 'Impossible... fall back... men...',
        victoryDialogue: 'Ha! Another fool crushed beneath my boot. Drag them to the cells.',
      );

  // ── Boss: Commander Valerus ───────────────────────────────────────────────

  static Boss commanderValerus() => Boss(
        id: 'boss_valerus',
        name: 'Commander Valerus',
        characterClass: CharacterClass.warrior,
        baseMaxHp: 520, baseMaxMp: 80, baseMaxSp: 160,
        baseStr: 38, baseAgi: 18, baseInt: 12, baseCon: 36,
        baseDef: 26, baseMdef: 14,
        baseCritChance: 0.14, baseCritDamage: 1.90,
        baseDodgeChance: 0.08, baseAccuracy: 0.92,
        baseSpeed: 16,
        skills: [SkillsData.heavySlash(), SkillsData.commanderCharge(), SkillsData.berserkerRage()],
        aiBehavior: AIBehavior.tactical,
        goldReward: 220, xpReward: 450,
        stageArea: StageArea.redSandColosseum,
        archetype: 'Gladiator',
        hasPhase2: false,
        introDialogue: 'The crowd hungers for blood. Let us not disappoint them.',
        deathDialogue: 'The Empire... will not... forgive this...',
        victoryDialogue: 'The empire is eternal. As am I. Take this wretch away.',
      );

  // ── Final Boss: Malakor ───────────────────────────────────────────────────

  static Boss malakor() => Boss(
        id: 'boss_malakor',
        name: 'Malakor the Shadow Sovereign',
        characterClass: CharacterClass.mage,
        baseMaxHp: 800, baseMaxMp: 300, baseMaxSp: 200,
        baseStr: 30, baseAgi: 22, baseInt: 48, baseCon: 32,
        baseDef: 20, baseMdef: 36,
        baseCritChance: 0.18, baseCritDamage: 2.10,
        baseDodgeChance: 0.12, baseAccuracy: 0.96,
        baseSpeed: 20,
        skills: [
          SkillsData.darkBlast(),
          SkillsData.shadowCurse(),
          SkillsData.commanderCharge(),
          SkillsData.curseWeakness(),
        ],
        phase2Skills: [SkillsData.voidStrike(), SkillsData.frostNova()],
        aiBehavior: AIBehavior.tactical,
        goldReward: 500, xpReward: 1000,
        stageArea: StageArea.imperialShadowArena,
        archetype: 'Necromancer',
        hasPhase2: true,
        introDialogue:
            'At last... a gladiator worthy of witnessing my ascension. '
            'The Shadow Realm shall consume you whole.',
        phase2Dialogue:
            'You DARE wound me?! I am IMMORTAL! Feel the full wrath of the void!',
        deathDialogue:
            'The shadow... cannot die... I will return... from the darkness...',
        victoryDialogue:
            'Pathetic. Your struggle entertains me. Take your place among my shadow thralls.',
      );

  // ── Lookup ────────────────────────────────────────────────────────────────

  static Map<StageArea, List<Enemy>> enemyPool = {
    StageArea.ironholdMines: [mineGladiator(), cageWolf(), shackledMage()],
    StageArea.redSandColosseum: [arenaAssassin(), colossumTank(), berserker()],
    StageArea.imperialShadowArena: [shadowNecromancer(), imperialGuard()],
  };

  static Boss bossForStage(StageArea area) {
    switch (area) {
      case StageArea.ironholdMines: return overseerSark();
      case StageArea.redSandColosseum: return commanderValerus();
      case StageArea.imperialShadowArena: return malakor();
    }
  }
}
