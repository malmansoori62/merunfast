import '../core/enums.dart';
import '../models/skills/base_skill.dart';
import '../models/skills/physical_skill.dart';
import '../models/skills/magic_skill.dart';
import '../models/skills/passive_skill.dart';

class SkillsData {
  SkillsData._();

  // ── BRIX — Warrior Skills ─────────────────────────────────────────────────

  static PhysicalSkill crushingBlow() => PhysicalSkill(
        id: 'crushing_blow',
        name: 'Crushing Blow',
        description: 'A powerful strike that deals 180% STR damage and may cause bleeding.',
        damageMultiplier: 1.80,
        staminaCost: 20,
        cooldown: 2,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.bleed, applyChance: 0.60, damage: 10),
        ],
        canBleed: true,
        critBonusMultiplier: 1.25,
      );

  static PhysicalSkill shieldWall() => PhysicalSkill(
        id: 'shield_wall',
        name: 'Shield Wall',
        description: 'Brace behind your shield, blocking damage and restoring stamina.',
        damageMultiplier: 0.0,
        staminaCost: 10,
        cooldown: 3,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.shield, applyChance: 1.0, damage: 60),
        ],
      );

  static PhysicalSkill berserkerRage() => PhysicalSkill(
        id: 'berserker_rage',
        name: 'Berserker Rage',
        description: 'Enter a fury state, boosting all damage at the cost of defense.',
        damageMultiplier: 0.0,
        staminaCost: 25,
        cooldown: 4,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.rage, applyChance: 1.0),
        ],
      );

  static PassiveSkill ironSkin() => PassiveSkill(
        id: 'iron_skin',
        name: 'Iron Skin',
        description: 'Toughened skin grants permanent +5 DEF and +20 HP.',
        defBonus: 5,
        hpBonus: 20,
      );

  static PhysicalSkill groundSlam() => PhysicalSkill(
        id: 'ground_slam',
        name: 'Ground Slam',
        description: 'Slam the ground, dealing 150% STR to all enemies and stunning.',
        damageMultiplier: 1.50,
        staminaCost: 30,
        cooldown: 3,
        isAreaDamage: true,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.stun, applyChance: 0.40),
        ],
      );

  // ── LYRA — Rogue Skills ───────────────────────────────────────────────────

  static PhysicalSkill backstab() => PhysicalSkill(
        id: 'backstab',
        name: 'Backstab',
        description: 'Strike from the shadows for 220% AGI damage with boosted crit.',
        damageMultiplier: 2.20,
        staminaCost: 18,
        cooldown: 2,
        usesAgi: true,
        critBonusMultiplier: 1.50,
      );

  static PhysicalSkill poisonDaggers() => PhysicalSkill(
        id: 'poison_daggers',
        name: 'Poison Daggers',
        description: 'Throw venomous daggers applying stacking poison (120% AGI).',
        damageMultiplier: 1.20,
        staminaCost: 15,
        cooldown: 2,
        usesAgi: true,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.poison, applyChance: 1.0, damage: 8),
        ],
      );

  static PhysicalSkill shadowstep() => PhysicalSkill(
        id: 'shadowstep',
        name: 'Shadowstep',
        description: 'Vanish into shadow, greatly boosting dodge and dealing 160% AGI on reappear.',
        damageMultiplier: 1.60,
        staminaCost: 22,
        cooldown: 3,
        usesAgi: true,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.weakness, applyChance: 1.0),
        ],
      );

  static PassiveSkill shadowMastery() => PassiveSkill(
        id: 'shadow_mastery',
        name: 'Shadow Mastery',
        description: 'Mastery of shadows gives +8% dodge and +5 AGI.',
        agiBonus: 5,
        dodgeBonus: 0.08,
      );

  static PhysicalSkill bladeDance() => PhysicalSkill(
        id: 'blade_dance',
        name: 'Blade Dance',
        description: 'A whirlwind of blades hitting all enemies for 130% AGI.',
        damageMultiplier: 1.30,
        staminaCost: 28,
        cooldown: 4,
        usesAgi: true,
        isAreaDamage: true,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.bleed, applyChance: 0.70, damage: 7),
        ],
      );

  // ── KAELEN — Mage Skills ──────────────────────────────────────────────────

  static MagicSkill fireball() => MagicSkill(
        id: 'fireball',
        name: 'Fireball',
        description: 'Hurl a ball of fire dealing 200% INT damage and burning the target.',
        damageMultiplier: 2.00,
        manaCost: 25,
        cooldown: 1,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.burn, applyChance: 0.80, damage: 14),
        ],
      );

  static MagicSkill arcaneBurst() => MagicSkill(
        id: 'arcane_burst',
        name: 'Arcane Burst',
        description: 'Release a burst of arcane energy hitting all enemies for 160% INT.',
        damageMultiplier: 1.60,
        manaCost: 35,
        cooldown: 2,
        isAreaDamage: true,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.silence, applyChance: 0.35),
        ],
      );

  static MagicSkill manaShield() => MagicSkill(
        id: 'mana_shield',
        name: 'Mana Shield',
        description: 'Convert mana into a protective barrier that absorbs damage.',
        damageMultiplier: 0.0,
        manaCost: 30,
        cooldown: 3,
        isSelfTarget: true,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.shield, applyChance: 1.0, damage: 80),
        ],
      );

  static PassiveSkill arcaneMind() => PassiveSkill(
        id: 'arcane_mind',
        name: 'Arcane Mind',
        description: 'Deep arcane knowledge grants +8 INT, +30 MP, and +3 MDEF.',
        intBonus: 8,
        mpBonus: 30,
        mdefBonus: 3,
      );

  static MagicSkill frostNova() => MagicSkill(
        id: 'frost_nova',
        name: 'Frost Nova',
        description: 'Explode with frost energy, freezing all enemies briefly.',
        damageMultiplier: 1.40,
        manaCost: 40,
        cooldown: 4,
        isAreaDamage: true,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.freeze, applyChance: 0.65),
        ],
      );

  // ── Enemy Skills ──────────────────────────────────────────────────────────

  static PhysicalSkill heavySlash() => PhysicalSkill(
        id: 'heavy_slash',
        name: 'Heavy Slash',
        description: 'A brutal slash dealing 160% STR.',
        damageMultiplier: 1.60,
        staminaCost: 15,
        cooldown: 2,
      );

  static PhysicalSkill savageBite() => PhysicalSkill(
        id: 'savage_bite',
        name: 'Savage Bite',
        description: 'A feral bite that causes bleeding.',
        damageMultiplier: 1.40,
        staminaCost: 12,
        cooldown: 2,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.bleed, applyChance: 0.75, damage: 9),
        ],
      );

  static MagicSkill darkBlast() => MagicSkill(
        id: 'dark_blast',
        name: 'Dark Blast',
        description: 'A blast of dark magic dealing 180% INT.',
        damageMultiplier: 1.80,
        manaCost: 20,
        cooldown: 2,
      );

  static PhysicalSkill deathStrike() => PhysicalSkill(
        id: 'death_strike',
        name: 'Death Strike',
        description: 'A lethal strike aimed at vital points — high crit chance.',
        damageMultiplier: 1.90,
        staminaCost: 20,
        cooldown: 3,
        critBonusMultiplier: 2.0,
      );

  static MagicSkill curseWeakness() => MagicSkill(
        id: 'curse_weakness',
        name: 'Curse of Weakness',
        description: 'Curse the target, reducing their damage output.',
        damageMultiplier: 0.80,
        manaCost: 15,
        cooldown: 3,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.weakness, applyChance: 1.0),
        ],
      );

  // ── Boss Skills ───────────────────────────────────────────────────────────

  static PhysicalSkill overseerWhip() => PhysicalSkill(
        id: 'overseer_whip',
        name: 'Overseer\'s Whip',
        description: 'Sark cracks his iron whip, bleeding the target for 5 turns.',
        damageMultiplier: 1.70,
        staminaCost: 20,
        cooldown: 2,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.bleed, applyChance: 1.0, damage: 12),
        ],
      );

  static PhysicalSkill commanderCharge() => PhysicalSkill(
        id: 'commander_charge',
        name: 'Commander\'s Charge',
        description: 'Valerus charges with devastating force, stunning the target.',
        damageMultiplier: 2.20,
        staminaCost: 25,
        cooldown: 3,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.stun, applyChance: 0.70),
        ],
      );

  static MagicSkill shadowCurse() => MagicSkill(
        id: 'shadow_curse',
        name: 'Shadow Curse',
        description: 'Malakor curses the hero, applying poison, bleed, and weakness.',
        damageMultiplier: 1.60,
        manaCost: 30,
        cooldown: 3,
        onHitEffects: [
          SkillEffect(type: StatusEffectType.poison, applyChance: 1.0, damage: 10),
          SkillEffect(type: StatusEffectType.bleed, applyChance: 1.0, damage: 8),
          SkillEffect(type: StatusEffectType.weakness, applyChance: 1.0),
        ],
      );

  static MagicSkill voidStrike() => MagicSkill(
        id: 'void_strike',
        name: 'Void Strike',
        description: 'Phase 2: A devastating void strike that deals 300% INT, ignores defenses.',
        damageMultiplier: 3.00,
        manaCost: 50,
        cooldown: 4,
        ignoresDefense: true,
      );

  // ── Skill map for lookup ──────────────────────────────────────────────────

  static final Map<String, BaseSkill Function()> registry = {
    'crushing_blow': crushingBlow,
    'shield_wall': shieldWall,
    'berserker_rage': berserkerRage,
    'iron_skin': ironSkin,
    'ground_slam': groundSlam,
    'backstab': backstab,
    'poison_daggers': poisonDaggers,
    'shadowstep': shadowstep,
    'shadow_mastery': shadowMastery,
    'blade_dance': bladeDance,
    'fireball': fireball,
    'arcane_burst': arcaneBurst,
    'mana_shield': manaShield,
    'arcane_mind': arcaneMind,
    'frost_nova': frostNova,
    'heavy_slash': heavySlash,
    'savage_bite': savageBite,
    'dark_blast': darkBlast,
    'death_strike': deathStrike,
    'curse_weakness': curseWeakness,
    'overseer_whip': overseerWhip,
    'commander_charge': commanderCharge,
    'shadow_curse': shadowCurse,
    'void_strike': voidStrike,
  };

  static BaseSkill? build(String id) => registry[id]?.call();
}
