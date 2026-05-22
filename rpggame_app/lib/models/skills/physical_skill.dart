import '../../core/enums.dart';
import 'base_skill.dart';

class PhysicalSkill extends BaseSkill {
  final bool canBleed;
  final double critBonusMultiplier;
  final bool usesAgi;

  PhysicalSkill({
    required super.id,
    required super.name,
    required super.description,
    required super.damageMultiplier,
    super.staminaCost = 15,
    super.manaCost = 0,
    super.cooldown = 0,
    super.onHitEffects = const [],
    super.isAreaDamage = false,
    this.canBleed = false,
    this.critBonusMultiplier = 1.0,
    this.usesAgi = false,
  }) : super(
          type: SkillType.physical,
          animationTrigger: AnimationTrigger.attack,
        );
}
