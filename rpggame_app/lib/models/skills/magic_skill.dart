import '../../core/enums.dart';
import 'base_skill.dart';

class MagicSkill extends BaseSkill {
  final bool ignoresDefense;
  final bool isSelfTarget;

  MagicSkill({
    required super.id,
    required super.name,
    required super.description,
    required super.damageMultiplier,
    super.manaCost = 20,
    super.staminaCost = 0,
    super.cooldown = 1,
    super.onHitEffects = const [],
    super.isAreaDamage = false,
    this.ignoresDefense = false,
    this.isSelfTarget = false,
  }) : super(
          type: SkillType.magic,
          animationTrigger: AnimationTrigger.skill,
        );
}
