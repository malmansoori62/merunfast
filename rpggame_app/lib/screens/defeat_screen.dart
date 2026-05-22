import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';

class DefeatScreen extends StatelessWidget {
  const DefeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    final hero = gp.hero!;
    final lastLog = gp.combat.combatLog.isNotEmpty
        ? gp.combat.combatLog.last.message
        : '';

    return Scaffold(
      backgroundColor: const Color(0xFF080812),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.skull, color: Colors.red, size: 80)
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(begin: const Offset(0.3, 0.3)),
              const SizedBox(height: 20),
              const Text(
                'DEFEATED',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                  letterSpacing: 6,
                ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 8),
              Text(
                '${hero.name} has fallen...',
                style: const TextStyle(color: Colors.white54, fontSize: 16),
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 20),
              if (lastLog.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lastLog,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ).animate().fadeIn(delay: 800.ms),
              const SizedBox(height: 40),
              _DefeatButton(
                label: 'TRY AGAIN',
                icon: Icons.refresh,
                color: Colors.amber,
                onTap: gp.retryBattle,
              ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3),
              const SizedBox(height: 12),
              _DefeatButton(
                label: 'RETURN TO MAP',
                icon: Icons.map,
                color: Colors.blueGrey,
                onTap: () {
                  hero.currentHp = hero.maxHp;
                  hero.currentMp = hero.maxMp;
                  hero.currentSp = hero.maxSp;
                  hero.clearAllEffects();
                  gp.goToStageMap();
                },
              ).animate().fadeIn(delay: 1100.ms).slideY(begin: 0.3),
              const SizedBox(height: 12),
              _DefeatButton(
                label: 'MAIN MENU',
                icon: Icons.home,
                color: Colors.grey,
                onTap: gp.goToMainMenu,
              ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefeatButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _DefeatButton(
      {required this.label,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 10),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5)),
            ],
          ),
        ),
      );
}
