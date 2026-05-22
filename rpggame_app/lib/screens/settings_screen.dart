import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    final audio = gp.audio;

    return Scaffold(
      backgroundColor: const Color(0xFF080812),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white54),
          onPressed: gp.goToMainMenu,
        ),
        title: const Text('Settings',
            style: TextStyle(color: Colors.white70, fontSize: 16)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionHeader('Audio'),
          _ToggleTile(
            label: 'Music',
            icon: Icons.music_note,
            value: audio.musicEnabled,
            onChanged: (v) => gp.applySettings(musicEnabled: v),
          ),
          _SliderTile(
            label: 'Music Volume',
            icon: Icons.volume_up,
            value: audio.musicVolume,
            onChanged: (v) => gp.applySettings(musicVolume: v),
          ),
          _ToggleTile(
            label: 'Sound Effects',
            icon: Icons.surround_sound,
            value: audio.sfxEnabled,
            onChanged: (v) => gp.applySettings(sfxEnabled: v),
          ),
          _SliderTile(
            label: 'SFX Volume',
            icon: Icons.equalizer,
            value: audio.sfxVolume,
            onChanged: (v) => gp.applySettings(sfxVolume: v),
          ),
          const SizedBox(height: 20),
          _SectionHeader('Game'),
          _ToggleTile(
            label: 'Debug Mode',
            icon: Icons.bug_report,
            subtitle: 'Shows raw stats, formulas, AI decisions',
            value: gp.debugMode,
            onChanged: (v) => gp.applySettings(debugMode: v),
          ),
          const SizedBox(height: 20),
          _SectionHeader('Data'),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Delete Save File',
                style: TextStyle(color: Colors.red)),
            subtitle: const Text('Cannot be undone',
                style: TextStyle(color: Colors.white38, fontSize: 12)),
            onTap: () => _confirmDelete(context, gp),
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'Gladiator Uprising  v1.0.0\n'
              'Built with Flutter & Dart',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, GameProvider gp) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Delete Save?',
            style: TextStyle(color: Colors.white)),
        content: const Text('All progress will be permanently lost.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              gp.deleteSave();
              Navigator.pop(ctx);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
              color: Colors.amber,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
      );
}

class _ToggleTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool value;
  final String? subtitle;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SwitchListTile(
          secondary: Icon(icon, color: Colors.white54),
          title: Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
          subtitle: subtitle != null
              ? Text(subtitle!,
                  style: const TextStyle(color: Colors.white38, fontSize: 11))
              : null,
          value: value,
          onChanged: onChanged,
          activeColor: Colors.amber,
        ),
      );
}

class _SliderTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final ValueChanged<double> onChanged;

  const _SliderTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white54, size: 20),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
            const Spacer(),
            SizedBox(
              width: 150,
              child: Slider(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.amber,
                inactiveColor: Colors.white12,
              ),
            ),
            Text('${(value * 100).round()}%',
                style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      );
}
