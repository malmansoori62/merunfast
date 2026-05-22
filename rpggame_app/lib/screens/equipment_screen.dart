import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/enums.dart';
import '../models/items/equipment.dart';
import '../widgets/item_card.dart';

class EquipmentScreen extends StatelessWidget {
  const EquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    final hero = gp.hero!;
    final inv = gp.inventory;

    return Scaffold(
      backgroundColor: const Color(0xFF080812),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white54),
          onPressed: gp.goToInventory,
        ),
        title: const Text('Equipment',
            style: TextStyle(color: Colors.white70, fontSize: 16)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stat summary
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hero.name,
                    style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    _StatLabel('STR', hero.str),
                    _StatLabel('AGI', hero.agi),
                    _StatLabel('INT', hero.intelligence),
                    _StatLabel('DEF', hero.def),
                    _StatLabel('MDEF', hero.mdef),
                    _StatLabel('HP', hero.maxHp),
                    _StatLabel('MP', hero.maxMp),
                    _StatLabel('CRIT',
                        '${(hero.critChance * 100).round()}%'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Equipment slots
          ...EquipmentSlot.values.map((slot) {
            final equipped = hero.equipped[slot];
            final available = inv.filterBySlot(slot);
            return _EquipSlot(
              slot: slot,
              equipped: equipped,
              available: available,
              onEquip: (item) => gp.equipItem(item),
              onUnequip: () => gp.unequipSlot(slot),
            );
          }),
        ],
      ),
    );
  }
}

class _StatLabel extends StatelessWidget {
  final String label;
  final dynamic value;
  const _StatLabel(this.label, this.value);

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12),
          children: [
            TextSpan(
                text: '$label ',
                style: const TextStyle(color: Colors.white38)),
            TextSpan(
                text: '$value',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      );
}

class _EquipSlot extends StatelessWidget {
  final EquipmentSlot slot;
  final Equipment? equipped;
  final List<Equipment> available;
  final ValueChanged<Equipment> onEquip;
  final VoidCallback onUnequip;

  const _EquipSlot({
    required this.slot,
    required this.equipped,
    required this.available,
    required this.onEquip,
    required this.onUnequip,
  });

  static const _slotIcons = {
    EquipmentSlot.weapon: Icons.gavel,
    EquipmentSlot.armor: Icons.security,
    EquipmentSlot.ring: Icons.circle_outlined,
    EquipmentSlot.amulet: Icons.lens_outlined,
    EquipmentSlot.shield: Icons.shield,
  };

  @override
  Widget build(BuildContext context) {
    final icon = _slotIcons[slot] ?? Icons.help_outline;
    final slotName = slot.name[0].toUpperCase() + slot.name.substring(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white38, size: 16),
              const SizedBox(width: 6),
              Text(slotName,
                  style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 6),
          if (equipped != null)
            Stack(
              children: [
                ItemCard(item: equipped!),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onUnequip,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ],
            )
          else
            GestureDetector(
              onTap: available.isNotEmpty
                  ? () => _showPicker(context, available)
                  : null,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: available.isNotEmpty
                          ? Colors.white24
                          : Colors.white12,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add,
                        color: available.isNotEmpty
                            ? Colors.white54
                            : Colors.white24,
                        size: 18),
                    const SizedBox(width: 8),
                    Text(
                      available.isNotEmpty
                          ? 'Equip ${available.length} available'
                          : 'No $slotName in inventory',
                      style: TextStyle(
                          color: available.isNotEmpty
                              ? Colors.white54
                              : Colors.white24,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext ctx, List<Equipment> items) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF1A1A2E),
      builder: (_) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ItemCard(
            item: items[i],
            actionLabel: 'Equip',
            onTap: () {
              onEquip(items[i]);
              Navigator.pop(ctx);
            },
          ),
        ),
      ),
    );
  }
}
