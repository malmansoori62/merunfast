import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../data/items_data.dart';
import '../widgets/item_card.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    final hero = gp.hero!;
    final area = gp.stage.currentArea;
    final stock = ItemsData.shopStock(area);

    return Scaffold(
      backgroundColor: const Color(0xFF080812),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white54),
          onPressed: gp.goToStageMap,
        ),
        title: const Text('The Merchant',
            style: TextStyle(color: Colors.white70, fontSize: 16)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${hero.gold}g',
                    style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Keeper greeting
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.06),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.storefront, color: Colors.amber, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      gp.story.getRandomShopGreeting(),
                      style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 13,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Stock grid
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: stock.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ItemCard(
                  item: stock[i],
                  showPrice: true,
                  actionLabel: hero.gold >= stock[i].buyPrice ? 'Buy' : null,
                  onTap: hero.gold >= stock[i].buyPrice
                      ? () => _buy(context, gp, stock[i])
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _buy(BuildContext ctx, GameProvider gp, dynamic item) {
    final success = gp.buyItem(item);
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor:
            success ? const Color(0xFF1A3A1A) : const Color(0xFF3A1A1A),
        content: Text(
          success
              ? '✓ Bought ${item.name} for ${item.buyPrice}g'
              : '✗ Not enough gold!',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
