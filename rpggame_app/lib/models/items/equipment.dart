import '../../core/enums.dart';
import 'base_item.dart';

class Equipment extends BaseItem {
  final EquipmentSlot slot;
  final int strBonus;
  final int agiBonus;
  final int intBonus;
  final int conBonus;
  final int defBonus;
  final int mdefBonus;
  final int hpBonus;
  final int mpBonus;
  final double critBonus;
  final double dodgeBonus;

  Equipment({
    required super.id,
    required super.name,
    required super.description,
    required super.rarity,
    required this.slot,
    this.strBonus = 0,
    this.agiBonus = 0,
    this.intBonus = 0,
    this.conBonus = 0,
    this.defBonus = 0,
    this.mdefBonus = 0,
    this.hpBonus = 0,
    this.mpBonus = 0,
    this.critBonus = 0.0,
    this.dodgeBonus = 0.0,
  }) : super(
          type: _slotToItemType(slot),
        );

  static ItemType _slotToItemType(EquipmentSlot slot) {
    switch (slot) {
      case EquipmentSlot.weapon: return ItemType.weapon;
      case EquipmentSlot.armor: return ItemType.armor;
      case EquipmentSlot.ring: return ItemType.ring;
      case EquipmentSlot.amulet: return ItemType.amulet;
      case EquipmentSlot.shield: return ItemType.shield;
    }
  }

  String get slotLabel {
    switch (slot) {
      case EquipmentSlot.weapon: return 'Weapon';
      case EquipmentSlot.armor: return 'Armor';
      case EquipmentSlot.ring: return 'Ring';
      case EquipmentSlot.amulet: return 'Amulet';
      case EquipmentSlot.shield: return 'Shield';
    }
  }

  List<String> get statSummary {
    final lines = <String>[];
    if (strBonus != 0) lines.add('STR +$strBonus');
    if (agiBonus != 0) lines.add('AGI +$agiBonus');
    if (intBonus != 0) lines.add('INT +$intBonus');
    if (conBonus != 0) lines.add('CON +$conBonus');
    if (defBonus != 0) lines.add('DEF +$defBonus');
    if (mdefBonus != 0) lines.add('MDEF +$mdefBonus');
    if (hpBonus != 0) lines.add('HP +$hpBonus');
    if (mpBonus != 0) lines.add('MP +$mpBonus');
    if (critBonus != 0.0) lines.add('Crit +${(critBonus * 100).round()}%');
    if (dodgeBonus != 0.0) lines.add('Dodge +${(dodgeBonus * 100).round()}%');
    return lines;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rarity': rarity.name,
        'slot': slot.name,
        'strBonus': strBonus,
        'agiBonus': agiBonus,
        'intBonus': intBonus,
        'conBonus': conBonus,
        'defBonus': defBonus,
        'mdefBonus': mdefBonus,
        'hpBonus': hpBonus,
        'mpBonus': mpBonus,
        'critBonus': critBonus,
        'dodgeBonus': dodgeBonus,
      };
}
