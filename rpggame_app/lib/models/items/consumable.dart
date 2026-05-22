import '../../core/enums.dart';
import 'base_item.dart';

enum ConsumableEffect { restoreHp, restoreMp, restoreSp, revive, fullRestore }

class Consumable extends BaseItem {
  final ConsumableEffect effect;
  final int effectAmount;
  final double effectPercent;
  final int maxStack;

  Consumable({
    required super.id,
    required super.name,
    required super.description,
    required super.rarity,
    required this.effect,
    this.effectAmount = 0,
    this.effectPercent = 0.0,
    this.maxStack = 10,
    super.quantity = 1,
  }) : super(type: ItemType.consumable);

  String get effectLabel {
    switch (effect) {
      case ConsumableEffect.restoreHp:
        return effectPercent > 0
            ? 'Restore ${(effectPercent * 100).round()}% HP'
            : 'Restore $effectAmount HP';
      case ConsumableEffect.restoreMp:
        return effectPercent > 0
            ? 'Restore ${(effectPercent * 100).round()}% MP'
            : 'Restore $effectAmount MP';
      case ConsumableEffect.restoreSp:
        return 'Restore $effectAmount SP';
      case ConsumableEffect.revive:
        return 'Revive with ${(effectPercent * 100).round()}% HP';
      case ConsumableEffect.fullRestore:
        return 'Fully restore HP and MP';
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rarity': rarity.name,
        'effect': effect.name,
        'effectAmount': effectAmount,
        'effectPercent': effectPercent,
        'quantity': quantity,
      };
}
