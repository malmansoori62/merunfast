import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../widgets/item_card.dart';
import '../widgets/health_bar.dart';
import '../models/items/base_item.dart';

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    final hero = gp.hero!;
    final loot = gp.lastLoot;
    final isBossKill = gp.stage.isAtBoss;

    return Scaffold(
      backgroundColor: const Color(0xFF080812),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      isBossKill ? 'BOSS DEFEATED!' : 'VICTORY!',
                      style: TextStyle(
                        fontSize: isBossKill ? 36 : 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.amber,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                              color: Colors.amber.withOpacity(0.6),
                              blurRadius: 20)
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(begin: const Offset(0.5, 0.5)),
                    const SizedBox(height: 8),
                    Text(
                      gp.stage.progressLabel,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 14),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 24),

                    // Rewards
                    if (loot != null) ...[
                      _RewardCard(
                        icon: Icons.military_tech,
                        label: 'Experience',
                        value: '+${loot.xp} XP',
                        color: Colors.purple,
                      ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.3),
                      const SizedBox(height: 8),
                      _RewardCard(
                        icon: Icons.monetization_on,
                        label: 'Gold',
                        value: '+${loot.gold}g',
                        color: Colors.amber,
                      ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.3),
                      const SizedBox(height: 16),
                      if (loot.items.isNotEmpty) ...[
                        const Text('LOOT',
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                                letterSpacing: 3)),
                        const SizedBox(height: 8),
                        ...loot.items
                            .map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ItemCard(item: item as BaseItem),
                                ))
                            .animate(interval: 100.ms)
                            .fadeIn()
                            .slideX(begin: 0.3),
                      ],
                    ],

                    // Hero status after battle
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        border: Border.all(color: Colors.white12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(hero.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          const SizedBox(height: 8),
                          HpBar(current: hero.currentHp, max: hero.maxHp),
                          const SizedBox(height: 6),
                          XpBar(
                              current: hero.currentXp,
                              max: hero.xpToNextLevel,
                              level: hero.level),
                        ],
                      ),
                    ).animate().fadeIn(delay: 800.ms),
                  ],
                ),
              ),
            ),
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (!gp.stage.isGameComplete)
                    _ActionButton(
                      label: gp.stage.isAtBoss && gp.stage.hasNextStage
                          ? 'NEXT STAGE'
                          : 'CONTINUE',
                      icon: Icons.arrow_forward,
                      color: Colors.amber,
                      onTap: () {
                        if (gp.stage.isAtBoss && gp.stage.hasNextStage) {
                          gp.stage.advanceStage();
                        }
                        gp.goToStageMap();
                      },
                    )
                  else
                    _ActionButton(
                      label: '🏆 GAME COMPLETE!',
                      icon: Icons.emoji_events,
                      color: Colors.amber,
                      onTap: gp.goToMainMenu,
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'INVENTORY',
                          icon: Icons.backpack,
                          color: Colors.blueGrey,
                          onTap: gp.goToInventory,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionButton(
                          label: 'SHOP',
                          icon: Icons.storefront,
                          color: Colors.green,
                          onTap: gp.goToShop,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _RewardCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          border: Border.all(color: color.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(label,
                style:
                    const TextStyle(color: Colors.white54, fontSize: 14)),
            const Spacer(),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.label,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontSize: 13)),
            ],
          ),
        ),
      );
}
