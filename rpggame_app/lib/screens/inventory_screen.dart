import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/enums.dart';
import '../widgets/item_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  ItemType? _filter;

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    final inv = gp.inventory;

    final items = _filter == null
        ? inv.items.toList()
        : inv.filterByType(_filter!);

    return Scaffold(
      backgroundColor: const Color(0xFF080812),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white54),
          onPressed: gp.goToStageMap,
        ),
        title: Text('Inventory (${inv.count}/${40})',
            style: const TextStyle(color: Colors.white70, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => gp.goToEquipment(),
            child: const Text('EQUIP',
                style: TextStyle(color: Colors.amber, fontSize: 12)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Gold display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                const SizedBox(width: 6),
                Text('${gp.hero?.gold ?? 0} Gold',
                    style: const TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('Value: ${inv.getTotalValue()}g',
                    style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                _FilterChip(label: 'All', active: _filter == null,
                    onTap: () => setState(() => _filter = null)),
                _FilterChip(label: 'Weapons', active: _filter == ItemType.weapon,
                    onTap: () => setState(() => _filter = ItemType.weapon)),
                _FilterChip(label: 'Armor', active: _filter == ItemType.armor,
                    onTap: () => setState(() => _filter = ItemType.armor)),
                _FilterChip(label: 'Consumables',
                    active: _filter == ItemType.consumable,
                    onTap: () => setState(() => _filter = ItemType.consumable)),
                _FilterChip(label: 'Accessories',
                    active: _filter == ItemType.ring,
                    onTap: () => setState(() => _filter = ItemType.ring)),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('No items',
                        style: TextStyle(color: Colors.white38)))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ItemCard(
                        item: items[i],
                        showPrice: true,
                        isSell: true,
                        actionLabel: 'Sell',
                        onTap: () => _confirmSell(context, gp, items[i]),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _confirmSell(BuildContext ctx, GameProvider gp, dynamic item) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Sell ${item.name}?',
            style: const TextStyle(color: Colors.white, fontSize: 15)),
        content: Text('Sell for ${item.sellPrice}g?',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white54))),
          TextButton(
            onPressed: () {
              gp.sellItem(item);
              Navigator.pop(ctx);
            },
            child: Text('Sell +${item.sellPrice}g',
                style: const TextStyle(
                    color: Colors.amber, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: active
                ? Colors.amber.withOpacity(0.2)
                : Colors.white.withOpacity(0.05),
            border: Border.all(
                color: active ? Colors.amber : Colors.white24),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(label,
              style: TextStyle(
                  color: active ? Colors.amber : Colors.white54,
                  fontSize: 12,
                  fontWeight:
                      active ? FontWeight.bold : FontWeight.normal)),
        ),
      );
}
