import '../../core/enums.dart';
import '../../core/constants.dart';

abstract class BaseItem {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final ItemRarity rarity;
  int quantity;

  BaseItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    this.quantity = 1,
  });

  int get buyPrice => GameConstants.itemBasePrices[rarity] ?? 50;
  int get sellPrice => (buyPrice * GameConstants.sellPriceMultiplier).round();

  bool get isStackable => type == ItemType.consumable;

  String get rarityLabel {
    switch (rarity) {
      case ItemRarity.common: return 'Common';
      case ItemRarity.uncommon: return 'Uncommon';
      case ItemRarity.rare: return 'Rare';
      case ItemRarity.epic: return 'Epic';
      case ItemRarity.legendary: return 'Legendary';
    }
  }

  Map<String, dynamic> toJson();
}
