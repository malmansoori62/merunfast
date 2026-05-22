import '../core/enums.dart';
import '../models/items/equipment.dart';
import '../models/items/consumable.dart';

class ItemsData {
  ItemsData._();

  // ── Consumables ───────────────────────────────────────────────────────────

  static Consumable healthPotion() => Consumable(
        id: 'health_potion',
        name: 'Health Potion',
        description: 'Restores 60 HP.',
        rarity: ItemRarity.common,
        effect: ConsumableEffect.restoreHp,
        effectAmount: 60,
      );

  static Consumable greaterHealthPotion() => Consumable(
        id: 'greater_health_potion',
        name: 'Greater Health Potion',
        description: 'Restores 40% of max HP.',
        rarity: ItemRarity.uncommon,
        effect: ConsumableEffect.restoreHp,
        effectPercent: 0.40,
      );

  static Consumable manaPotion() => Consumable(
        id: 'mana_potion',
        name: 'Mana Potion',
        description: 'Restores 50 MP.',
        rarity: ItemRarity.common,
        effect: ConsumableEffect.restoreMp,
        effectAmount: 50,
      );

  static Consumable staminaElixir() => Consumable(
        id: 'stamina_elixir',
        name: 'Stamina Elixir',
        description: 'Restores 40 SP and clears Exhaustion.',
        rarity: ItemRarity.common,
        effect: ConsumableEffect.restoreSp,
        effectAmount: 40,
      );

  static Consumable reviveScroll() => Consumable(
        id: 'revive_scroll',
        name: 'Revive Scroll',
        description: 'Revive from KO with 25% HP.',
        rarity: ItemRarity.rare,
        effect: ConsumableEffect.revive,
        effectPercent: 0.25,
        maxStack: 3,
      );

  static Consumable elixirOfLife() => Consumable(
        id: 'elixir_of_life',
        name: 'Elixir of Life',
        description: 'Fully restores HP and MP.',
        rarity: ItemRarity.epic,
        effect: ConsumableEffect.fullRestore,
        maxStack: 2,
      );

  // ── Weapons ───────────────────────────────────────────────────────────────

  static Equipment ironSword() => Equipment(
        id: 'iron_sword',
        name: 'Iron Sword',
        description: 'A standard gladiatorial short sword.',
        rarity: ItemRarity.common,
        slot: EquipmentSlot.weapon,
        strBonus: 4, agiBonus: 1,
      );

  static Equipment shadowBlade() => Equipment(
        id: 'shadow_blade',
        name: 'Shadow Blade',
        description: 'A blade forged in shadow, swift and silent.',
        rarity: ItemRarity.rare,
        slot: EquipmentSlot.weapon,
        agiBonus: 8, strBonus: 4, critBonus: 0.05,
      );

  static Equipment furyAxe() => Equipment(
        id: 'fury_axe',
        name: 'Fury Axe',
        description: 'A massive axe that channels rage into each blow.',
        rarity: ItemRarity.rare,
        slot: EquipmentSlot.weapon,
        strBonus: 12, critBonus: 0.04,
      );

  static Equipment voidStaff() => Equipment(
        id: 'void_staff',
        name: 'Void Staff',
        description: 'Channels void energy, amplifying arcane power greatly.',
        rarity: ItemRarity.epic,
        slot: EquipmentSlot.weapon,
        intBonus: 16, mpBonus: 30, critBonus: 0.06,
      );

  static Equipment malakorsScepter() => Equipment(
        id: 'malakors_scepter',
        name: 'Malakor\'s Scepter',
        description: 'The Shadow Sovereign\'s weapon. Pure arcane devastation.',
        rarity: ItemRarity.legendary,
        slot: EquipmentSlot.weapon,
        intBonus: 28, mpBonus: 60, strBonus: 8, critBonus: 0.10,
      );

  // ── Armor ─────────────────────────────────────────────────────────────────

  static Equipment leatherVest() => Equipment(
        id: 'leather_vest',
        name: 'Leather Vest',
        description: 'Light leather armor offering minimal protection.',
        rarity: ItemRarity.common,
        slot: EquipmentSlot.armor,
        defBonus: 4, hpBonus: 15,
      );

  static Equipment chainmail() => Equipment(
        id: 'chainmail',
        name: 'Chainmail',
        description: 'Interlocked iron rings form a reliable defense.',
        rarity: ItemRarity.uncommon,
        slot: EquipmentSlot.armor,
        defBonus: 8, hpBonus: 25,
      );

  static Equipment imperialPlate() => Equipment(
        id: 'imperial_plate',
        name: 'Imperial Plate',
        description: 'Full plate armor worn by imperial champions.',
        rarity: ItemRarity.epic,
        slot: EquipmentSlot.armor,
        defBonus: 20, mdefBonus: 8, hpBonus: 60, conBonus: 6,
      );

  // ── Shields ───────────────────────────────────────────────────────────────

  static Equipment woodenShield() => Equipment(
        id: 'wooden_shield',
        name: 'Wooden Shield',
        description: 'A battered round shield of hard wood.',
        rarity: ItemRarity.common,
        slot: EquipmentSlot.shield,
        defBonus: 3, hpBonus: 10,
      );

  static Equipment towerShield() => Equipment(
        id: 'tower_shield',
        name: 'Tower Shield',
        description: 'An enormous iron shield, nearly impenetrable.',
        rarity: ItemRarity.rare,
        slot: EquipmentSlot.shield,
        defBonus: 14, hpBonus: 30, mdefBonus: 4,
      );

  // ── Rings ─────────────────────────────────────────────────────────────────

  static Equipment ringOfStrength() => Equipment(
        id: 'ring_strength',
        name: 'Ring of Strength',
        description: 'Infused with warrior enchantments.',
        rarity: ItemRarity.uncommon,
        slot: EquipmentSlot.ring,
        strBonus: 4, conBonus: 2,
      );

  static Equipment ringOfShadows() => Equipment(
        id: 'ring_shadows',
        name: 'Ring of Shadows',
        description: 'Grants the wearer uncanny speed and stealth.',
        rarity: ItemRarity.rare,
        slot: EquipmentSlot.ring,
        agiBonus: 6, dodgeBonus: 0.05,
      );

  static Equipment arcaneRing() => Equipment(
        id: 'arcane_ring',
        name: 'Arcane Ring',
        description: 'Concentrates arcane energy into your spells.',
        rarity: ItemRarity.rare,
        slot: EquipmentSlot.ring,
        intBonus: 8, mpBonus: 20, critBonus: 0.04,
      );

  // ── Amulets ───────────────────────────────────────────────────────────────

  static Equipment amuletOfConstitution() => Equipment(
        id: 'amulet_constitution',
        name: 'Amulet of Constitution',
        description: 'Enhances the wearer\'s vitality and resilience.',
        rarity: ItemRarity.uncommon,
        slot: EquipmentSlot.amulet,
        hpBonus: 40, conBonus: 4, mdefBonus: 3,
      );

  // ── All shop stock (by stage) ─────────────────────────────────────────────

  static List<dynamic> shopStock(StageArea area) {
    final base = [healthPotion(), manaPotion(), staminaElixir()];
    switch (area) {
      case StageArea.ironholdMines:
        return [...base, ironSword(), leatherVest(), woodenShield(), ringOfStrength()];
      case StageArea.redSandColosseum:
        return [...base, greaterHealthPotion(), chainmail(), shadowBlade(),
                furyAxe(), towerShield(), ringOfShadows(), arcaneRing(),
                amuletOfConstitution()];
      case StageArea.imperialShadowArena:
        return [...base, reviveScroll(), elixirOfLife(), imperialPlate(),
                voidStaff(), malakorsScepter()];
    }
  }

  // ── Registry for loot system lookup ──────────────────────────────────────

  static final Map<String, dynamic Function()> registry = {
    'health_potion': healthPotion,
    'greater_health_potion': greaterHealthPotion,
    'mana_potion': manaPotion,
    'stamina_elixir': staminaElixir,
    'revive_scroll': reviveScroll,
    'elixir_of_life': elixirOfLife,
    'iron_sword': ironSword,
    'shadow_blade': shadowBlade,
    'fury_axe': furyAxe,
    'void_staff': voidStaff,
    'leather_vest': leatherVest,
    'chainmail': chainmail,
    'imperial_plate': imperialPlate,
    'wooden_shield': woodenShield,
    'tower_shield': towerShield,
    'ring_strength': ringOfStrength,
    'ring_shadows': ringOfShadows,
    'arcane_ring': arcaneRing,
    'amulet_constitution': amuletOfConstitution,
    // Placeholder IDs used in enemy loot tables
    'wolf_pelt': () => healthPotion(),
    'arcane_tome': () => manaPotion(),
  };

  static dynamic build(String id) => registry[id]?.call();
}
