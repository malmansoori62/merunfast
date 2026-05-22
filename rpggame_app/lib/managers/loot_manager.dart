import 'dart:math';
import '../core/enums.dart';
import '../core/constants.dart';
import '../models/character/enemy.dart';
import '../models/items/base_item.dart';
import '../models/items/equipment.dart';
import '../models/items/consumable.dart';
import '../data/items_data.dart';

class LootResult {
  final int gold;
  final int xp;
  final List<BaseItem> items;

  const LootResult({
    required this.gold,
    required this.xp,
    required this.items,
  });
}

class LootManager {
  final Random _rng = Random();

  LootResult generateLoot(List<Enemy> defeatedEnemies, StageArea area) {
    int totalGold = 0;
    int totalXp = 0;
    final List<BaseItem> loot = [];

    for (final enemy in defeatedEnemies) {
      totalGold += _randomGold(enemy.goldReward);
      totalXp += enemy.xpReward;
      loot.addAll(_rollEnemyLoot(enemy));
    }

    // Bonus random item drop based on stage
    if (_rng.nextDouble() < 0.45) {
      final bonus = _generateRandomItem(area);
      if (bonus != null) loot.add(bonus);
    }

    return LootResult(gold: totalGold, xp: totalXp, items: loot);
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  int _randomGold(int base) {
    final variance = (base * GameConstants.goldVariance).round();
    return base - variance + _rng.nextInt(variance * 2 + 1);
  }

  List<BaseItem> _rollEnemyLoot(Enemy enemy) {
    final results = <BaseItem>[];
    for (final entry in enemy.lootTable) {
      if (_rng.nextDouble() <= entry.dropChance) {
        final item = ItemsData.build(entry.itemId);
        if (item != null) results.add(item as BaseItem);
      }
    }
    return results;
  }

  BaseItem? _generateRandomItem(StageArea area) {
    final rarity = _rollRarity();
    return _buildItemForRarity(rarity, area);
  }

  ItemRarity _rollRarity() {
    final roll = _rng.nextDouble();
    double cumulative = 0.0;
    for (final entry in GameConstants.lootDropRates.entries) {
      cumulative += entry.value;
      if (roll <= cumulative) return entry.key;
    }
    return ItemRarity.common;
  }

  BaseItem? _buildItemForRarity(ItemRarity rarity, StageArea area) {
    // Consumables for common/uncommon
    if (rarity == ItemRarity.common) {
      final roll = _rng.nextInt(3);
      if (roll == 0) return ItemsData.healthPotion();
      if (roll == 1) return ItemsData.manaPotion();
      return ItemsData.staminaElixir();
    }
    if (rarity == ItemRarity.uncommon) {
      return _randomEquipment(ItemRarity.uncommon, area);
    }
    if (rarity == ItemRarity.rare) {
      return _rng.nextBool()
          ? _randomEquipment(ItemRarity.rare, area)
          : ItemsData.reviveScroll();
    }
    if (rarity == ItemRarity.epic) {
      return _randomEquipment(ItemRarity.epic, area);
    }
    // Legendary
    return _randomEquipment(ItemRarity.legendary, area);
  }

  Equipment? _randomEquipment(ItemRarity rarity, StageArea area) {
    final stock = ItemsData.shopStock(area)
        .whereType<Equipment>()
        .where((e) => e.rarity == rarity)
        .toList();
    if (stock.isEmpty) return null;
    return stock[_rng.nextInt(stock.length)];
  }
}
