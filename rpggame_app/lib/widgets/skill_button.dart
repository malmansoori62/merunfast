import 'package:flutter/material.dart';
import '../models/skills/base_skill.dart';
import '../core/enums.dart';

class SkillButton extends StatelessWidget {
  final BaseSkill skill;
  final VoidCallback? onTap;
  final int index;
  final bool isEnabled;

  const SkillButton({
    super.key,
    required this.skill,
    required this.index,
    this.onTap,
    this.isEnabled = true,
  });

  Color get _skillColor {
    switch (skill.type) {
      case SkillType.physical: return const Color(0xFFCC4444);
      case SkillType.magic: return const Color(0xFF4466FF);
      case SkillType.passive: return const Color(0xFF44AA66);
    }
  }

  IconData get _skillIcon {
    switch (skill.type) {
      case SkillType.physical: return Icons.sports_martial_arts;
      case SkillType.magic: return Icons.auto_fix_high;
      case SkillType.passive: return Icons.shield;
    }
  }

  @override
  Widget build(BuildContext context) {
    final canUse = isEnabled && !skill.isOnCooldown;
    final color = canUse ? _skillColor : Colors.grey.shade700;

    return GestureDetector(
      onTap: canUse ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: canUse ? color.withOpacity(0.15) : const Color(0xFF1A1A2E),
          border: Border.all(color: color, width: canUse ? 1.5 : 1.0),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(_skillIcon, color: color, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    skill.name,
                    style: TextStyle(
                      color: canUse ? Colors.white : Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (skill.isOnCooldown)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${skill.currentCooldown}',
                      style: const TextStyle(
                          color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (skill.manaCost > 0)
                  _CostChip(label: '${skill.manaCost}MP', color: Colors.blue),
                if (skill.staminaCost > 0)
                  _CostChip(label: '${skill.staminaCost}SP', color: Colors.amber),
                const Spacer(),
                if (skill.type != SkillType.passive && skill.damageMultiplier > 0)
                  Text(
                    '${(skill.damageMultiplier * 100).round()}%',
                    style: TextStyle(
                        color: color.withOpacity(0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CostChip extends StatelessWidget {
  final String label;
  final Color color;
  const _CostChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Text(label,
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      );
}
