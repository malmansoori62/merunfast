import 'package:flutter/material.dart';
import '../models/status_effect.dart';
import '../core/enums.dart';

class StatusBadge extends StatelessWidget {
  final StatusEffect effect;
  const StatusBadge({super.key, required this.effect});

  Color get _color {
    switch (effect.type) {
      case StatusEffectType.bleed: return Colors.red;
      case StatusEffectType.burn: return Colors.deepOrange;
      case StatusEffectType.poison: return Colors.green;
      case StatusEffectType.stun: return Colors.yellow;
      case StatusEffectType.freeze: return Colors.lightBlue;
      case StatusEffectType.weakness: return Colors.purple;
      case StatusEffectType.rage: return Colors.red.shade900;
      case StatusEffectType.shield: return Colors.blue;
      case StatusEffectType.silence: return Colors.grey;
      case StatusEffectType.exhaustion: return Colors.brown;
    }
  }

  String get _icon {
    switch (effect.type) {
      case StatusEffectType.bleed: return '🩸';
      case StatusEffectType.burn: return '🔥';
      case StatusEffectType.poison: return '☠️';
      case StatusEffectType.stun: return '⚡';
      case StatusEffectType.freeze: return '❄️';
      case StatusEffectType.weakness: return '⬇️';
      case StatusEffectType.rage: return '💢';
      case StatusEffectType.shield: return '🛡️';
      case StatusEffectType.silence: return '🔇';
      case StatusEffectType.exhaustion: return '😵';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${effect.displayName} (${effect.duration} turns'
          '${effect.stacks > 1 ? ', x${effect.stacks}' : ''})',
      child: Container(
        margin: const EdgeInsets.only(right: 4, bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: _color.withOpacity(0.2),
          border: Border.all(color: _color.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_icon, style: const TextStyle(fontSize: 10)),
            const SizedBox(width: 2),
            Text(
              '${effect.duration}',
              style: TextStyle(
                color: _color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (effect.stacks > 1)
              Text(
                'x${effect.stacks}',
                style: TextStyle(
                    color: _color.withOpacity(0.8), fontSize: 9),
              ),
          ],
        ),
      ),
    );
  }
}

class StatusBadgeRow extends StatelessWidget {
  final List<StatusEffect> effects;
  const StatusBadgeRow({super.key, required this.effects});

  @override
  Widget build(BuildContext context) {
    if (effects.isEmpty) return const SizedBox.shrink();
    return Wrap(
      children: effects.map((e) => StatusBadge(effect: e)).toList(),
    );
  }
}
