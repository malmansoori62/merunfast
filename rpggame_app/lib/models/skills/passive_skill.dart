import '../../core/enums.dart';
import 'base_skill.dart';

enum PassiveTrigger { onBattleStart, onLevelUp, always }

class PassiveSkill extends BaseSkill {
  final PassiveTrigger trigger;
  final int strBonus;
  final int agiBonus;
  final int intBonus;
  final int defBonus;
  final int mdefBonus;
  final int hpBonus;
  final int mpBonus;
  final double critChanceBonus;
  final double dodgeBonus;

  PassiveSkill({
    required super.id,
    required super.name,
    required super.description,
    this.trigger = PassiveTrigger.always,
    this.strBonus = 0,
    this.agiBonus = 0,
    this.intBonus = 0,
    this.defBonus = 0,
    this.mdefBonus = 0,
    this.hpBonus = 0,
    this.mpBonus = 0,
    this.critChanceBonus = 0.0,
    this.dodgeBonus = 0.0,
  }) : super(
          type: SkillType.passive,
          damageMultiplier: 0,
          cooldown: 0,
          animationTrigger: AnimationTrigger.statusApplied,
        );
}
