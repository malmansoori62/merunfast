import 'enums.dart';

class GameConstants {
  GameConstants._();

  // ── Combat ────────────────────────────────────────────────────────────────
  static const int spRegenPerTurn = 5;
  static const double defendDamageReduction = 0.35;
  static const double defendSpRestorePercent = 0.25;
  static const double defendTempDefenseBonus = 0.20;
  static const double critDamageMultiplier = 1.75;
  static const double minDamage = 1.0;
  static const double exhaustionDamagePenalty = 0.50;
  static const double escapeBaseChance = 0.40;

  // ── Boss ──────────────────────────────────────────────────────────────────
  static const double bossPhase2HpPercent = 0.50;
  static const double bossPhase2DamageMultiplier = 1.50;

  // ── Leveling ──────────────────────────────────────────────────────────────
  static const int baseXpRequired = 100;
  static const double xpLevelScaling = 1.50;
  static const int statPointsPerLevel = 3;
  static const int skillUnlockInterval = 2;
  static const int maxLevel = 30;

  // ── Loot ──────────────────────────────────────────────────────────────────
  static const Map<ItemRarity, double> lootDropRates = {
    ItemRarity.common: 0.50,
    ItemRarity.uncommon: 0.28,
    ItemRarity.rare: 0.15,
    ItemRarity.epic: 0.06,
    ItemRarity.legendary: 0.01,
  };

  // ── Economy ───────────────────────────────────────────────────────────────
  static const Map<ItemRarity, int> itemBasePrices = {
    ItemRarity.common: 50,
    ItemRarity.uncommon: 150,
    ItemRarity.rare: 400,
    ItemRarity.epic: 1200,
    ItemRarity.legendary: 3000,
  };
  static const double sellPriceMultiplier = 0.40;

  static const Map<StageArea, int> stageGoldBase = {
    StageArea.ironholdMines: 20,
    StageArea.redSandColosseum: 45,
    StageArea.imperialShadowArena: 80,
  };
  static const double goldVariance = 0.30;

  static const Map<StageArea, int> stageXpBase = {
    StageArea.ironholdMines: 50,
    StageArea.redSandColosseum: 100,
    StageArea.imperialShadowArena: 180,
  };

  // ── Inventory ─────────────────────────────────────────────────────────────
  static const int maxInventorySize = 40;

  // ── Status Effects ────────────────────────────────────────────────────────
  static const Map<StatusEffectType, int> defaultStatusDurations = {
    StatusEffectType.bleed: 3,
    StatusEffectType.burn: 3,
    StatusEffectType.poison: 4,
    StatusEffectType.stun: 1,
    StatusEffectType.freeze: 2,
    StatusEffectType.weakness: 3,
    StatusEffectType.rage: 4,
    StatusEffectType.shield: 3,
    StatusEffectType.silence: 2,
    StatusEffectType.exhaustion: 2,
  };

  static const Map<StatusEffectType, int> maxStatusStacks = {
    StatusEffectType.bleed: 3,
    StatusEffectType.burn: 1,
    StatusEffectType.poison: 5,
    StatusEffectType.stun: 1,
    StatusEffectType.freeze: 1,
    StatusEffectType.weakness: 2,
    StatusEffectType.rage: 1,
    StatusEffectType.shield: 1,
    StatusEffectType.silence: 1,
    StatusEffectType.exhaustion: 1,
  };

  // ── Stat Growth per Level ─────────────────────────────────────────────────
  static const Map<CharacterClass, Map<String, int>> levelStatGrowth = {
    CharacterClass.warrior: {
      'hp': 18, 'mp': 3, 'sp': 8, 'str': 3, 'agi': 1, 'int': 0,
      'con': 3, 'def': 2, 'mdef': 1,
    },
    CharacterClass.rogue: {
      'hp': 12, 'mp': 5, 'sp': 10, 'str': 1, 'agi': 4, 'int': 1,
      'con': 1, 'def': 1, 'mdef': 1,
    },
    CharacterClass.mage: {
      'hp': 8, 'mp': 18, 'sp': 4, 'str': 0, 'agi': 1, 'int': 5,
      'con': 1, 'def': 0, 'mdef': 3,
    },
  };

  // ── XP requirement for a given level ─────────────────────────────────────
  static int xpRequired(int level) {
    if (level <= 1) return baseXpRequired;
    return (baseXpRequired * _pow(xpLevelScaling, level - 1)).round();
  }

  static double _pow(double base, int exp) {
    double result = 1.0;
    for (int i = 0; i < exp; i++) result *= base;
    return result;
  }
}
