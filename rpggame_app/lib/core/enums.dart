enum CharacterClass { warrior, rogue, mage }

enum SkillType { physical, magic, passive }

enum StatusEffectType {
  bleed,
  burn,
  poison,
  stun,
  freeze,
  weakness,
  rage,
  shield,
  silence,
  exhaustion,
}

enum ItemRarity { common, uncommon, rare, epic, legendary }

enum EquipmentSlot { weapon, armor, ring, amulet, shield }

enum ItemType { weapon, armor, ring, amulet, shield, consumable }

enum CombatState {
  initializing,
  playerTurn,
  processingAction,
  enemyTurn,
  applyingEffects,
  victory,
  defeat,
  escaped,
}

enum CombatAction { attack, skill, defend, useItem, escape }

enum AIBehavior { aggressive, defensive, tactical, berserker, support }

enum DamageType { physical, magical, trueDamage }

enum StageArea {
  ironholdMines,
  redSandColosseum,
  imperialShadowArena,
}

enum BossPhase { phase1, phase2 }

enum AnimationTrigger {
  attack,
  skill,
  takeDamage,
  criticalHit,
  death,
  bossTransform,
  heal,
  statusApplied,
  defend,
}

enum LogType { combat, status, system, story }
