import 'package:flutter/material.dart';
import '../models/items/base_item.dart';
import '../models/items/equipment.dart';
import '../models/items/consumable.dart';
import '../core/enums.dart';

class ItemCard extends StatelessWidget {
  final BaseItem item;
  final VoidCallback? onTap;
  final String? actionLabel;
  final bool showPrice;
  final bool isSell;

  const ItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.actionLabel,
    this.showPrice = false,
    this.isSell = false,
  });

  Color get _rarityColor {
    switch (item.rarity) {
      case ItemRarity.common: return Colors.grey;
      case ItemRarity.uncommon: return Colors.green;
      case ItemRarity.rare: return const Color(0xFF4488FF);
      case ItemRarity.epic: return Colors.purple;
      case ItemRarity.legendary: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          border: Border.all(color: _rarityColor.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 6,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _rarityColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: TextStyle(
                              color: _rarityColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      Text(item.rarityLabel,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                if (item is Consumable && item.quantity > 1)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('x${item.quantity}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(item.description,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            if (item is Equipment) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: (item as Equipment)
                    .statSummary
                    .map((s) => Text(s,
                        style: const TextStyle(
                            color: Colors.lightGreenAccent, fontSize: 10)))
                    .toList(),
              ),
            ],
            if (item is Consumable) ...[
              const SizedBox(height: 4),
              Text((item as Consumable).effectLabel,
                  style: const TextStyle(
                      color: Colors.lightGreenAccent, fontSize: 11)),
            ],
            if (showPrice) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isSell
                        ? '💰 Sell: ${item.sellPrice}g'
                        : '💰 ${item.buyPrice}g',
                    style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  if (actionLabel != null && onTap != null)
                    TextButton(
                      onPressed: onTap,
                      style: TextButton.styleFrom(
                        backgroundColor: _rarityColor.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(actionLabel!,
                          style: TextStyle(
                              color: _rarityColor, fontSize: 12)),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
