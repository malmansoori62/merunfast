import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  bool _hasSave = false;

  @override
  void initState() {
    super.initState();
    _checkSave();
    context.read<GameProvider>().audio.playMainMenuMusic();
  }

  Future<void> _checkSave() async {
    final has = await context.read<GameProvider>().hasSave();
    if (mounted) setState(() => _hasSave = has);
  }

  @override
  Widget build(BuildContext context) {
    final gp = context.read<GameProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFF080812),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.6,
                colors: [Color(0xFF1A0A2E), Color(0xFF080812)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Text(
                    'GLADIATOR',
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                      color: Colors.amber,
                      letterSpacing: 8,
                      shadows: [
                        Shadow(color: Colors.amber.withOpacity(0.5), blurRadius: 20)
                      ],
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3),
                  const SizedBox(height: 6),
                  Text(
                    'UPRISING',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.amber.withOpacity(0.7),
                      letterSpacing: 10,
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                  const SizedBox(height: 8),
                  const Text(
                    'A Dark Fantasy Turn-Based RPG',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ).animate().fadeIn(delay: 700.ms),
                  const Spacer(flex: 2),
                  _MenuButton(
                    label: 'NEW GAME',
                    icon: Icons.sports_martial_arts,
                    onTap: gp.goToCharacterSelect,
                  ).animate().fadeIn(delay: 900.ms).slideX(begin: -0.2),
                  const SizedBox(height: 14),
                  if (_hasSave)
                    _MenuButton(
                      label: 'CONTINUE',
                      icon: Icons.play_arrow_rounded,
                      color: Colors.greenAccent,
                      onTap: gp.loadGame,
                    ).animate().fadeIn(delay: 1000.ms).slideX(begin: -0.2),
                  if (_hasSave) const SizedBox(height: 14),
                  _MenuButton(
                    label: 'SETTINGS',
                    icon: Icons.settings,
                    color: Colors.blueGrey,
                    onTap: gp.goToSettings,
                  ).animate().fadeIn(delay: 1100.ms).slideX(begin: -0.2),
                  const Spacer(flex: 3),
                  const Text('v1.0.0  |  Gladiator Uprising',
                          style: TextStyle(color: Colors.white24, fontSize: 12))
                      .animate()
                      .fadeIn(delay: 1300.ms),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<GameProvider>().audio.playButtonClick();
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(8),
          color: color.withOpacity(0.08),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3)),
          ],
        ),
      ),
    );
  }
}
