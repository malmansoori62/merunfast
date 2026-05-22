import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../widgets/health_bar.dart';

class StageMapScreen extends StatelessWidget {
  const StageMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    final hero = gp.hero!;
    final stage = gp.stage;

    return Scaffold(
      backgroundColor: const Color(0xFF080812),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(stage.currentStageName,
            style: const TextStyle(
                color: Colors.amber, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white38),
            onPressed: gp.goToSettings,
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white38),
            onPressed: gp.goToMainMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          // Hero status card
          _HeroCard(hero: hero),

          // Stage progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(stage.currentStageSubtitle,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12,
                            fontStyle: FontStyle.italic)),
                    const Spacer(),
                    Text(stage.progressLabel,
                        style: const TextStyle(
                            color: Colors.amber, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: stage.stageProgress,
                  backgroundColor: Colors.white12,
                  valueColor:
                      const AlwaysStoppedAnimation(Colors.amber),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),

          // Narration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                border: Border.all(color: Colors.white12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                stage.getCurrentNarration(),
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    height: 1.4),
              ),
            ),
          ).animate().fadeIn(duration: 600.ms),

          const Spacer(),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _PrimaryButton(
                  label: stage.isAtBoss
                      ? '⚠️  FACE THE BOSS'
                      : 'NEXT BATTLE',
                  color: stage.isAtBoss ? Colors.red : Colors.amber,
                  onTap: () {
                    if (stage.isAtBoss) {
                      gp.startBossBattle();
                    } else {
                      gp.startNextBattle();
                    }
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: _SecondaryButton(
                            label: 'Inventory',
                            icon: Icons.backpack,
                            onTap: gp.goToInventory)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _SecondaryButton(
                            label: 'Equip',
                            icon: Icons.shield,
                            onTap: gp.goToEquipment)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _SecondaryButton(
                            label: 'Skills',
                            icon: Icons.auto_fix_high,
                            onTap: gp.goToSkillTree)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _SecondaryButton(
                            label: 'Shop',
                            icon: Icons.storefront,
                            onTap: gp.goToShop)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final dynamic hero;
  const _HeroCard({required this.hero});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(hero.name,
                      style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Lv.${hero.level}',
                        style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                  const Spacer(),
                  const Icon(Icons.monetization_on,
                      color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text('${hero.gold}g',
                      style: const TextStyle(
                          color: Colors.amber, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              HpBar(current: hero.currentHp, max: hero.maxHp),
              const SizedBox(height: 4),
              MpBar(current: hero.currentMp, max: hero.maxMp),
              const SizedBox(height: 4),
              SpBar(current: hero.currentSp, max: hero.maxSp),
              const SizedBox(height: 4),
              XpBar(
                  current: hero.currentXp,
                  max: hero.xpToNextLevel,
                  level: hero.level),
            ],
          ),
        ),
      );
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _PrimaryButton(
      {required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2)),
        ),
      );
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _SecondaryButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white54, size: 18),
              const SizedBox(height: 3),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 10)),
            ],
          ),
        ),
      );
}
