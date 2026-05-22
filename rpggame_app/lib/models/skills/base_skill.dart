import '../../core/enums.dart';
import '../status_effect.dart';

class SkillEffect {
  final StatusEffectType type;
  final double applyChance;
  final int? damage;

  const SkillEffect({
    required this.type,
    this.applyChance = 1.0,
    this.damage,
  });

  StatusEffect buildEffect() {
    switch (type) {
      case StatusEffectType.bleed:
        return StatusEffect.bleed(damage: damage ?? 8);
      case StatusEffectType.burn:
        return StatusEffect.burn(damage: damage ?? 14);
      case StatusEffectType.poison:
        return StatusEffect.poison(damage: damage ?? 6);
      case StatusEffectType.stun:
        return StatusEffect.stun();
      case StatusEffectType.freeze:
        return StatusEffect.freeze();
      case StatusEffectType.weakness:
        return StatusEffect.weakness();
      case StatusEffectType.rage:
        return StatusEffect.rage();
      case StatusEffectType.shield:
        return StatusEffect.shield(hp: damage ?? 40);
      case StatusEffectType.silence:
        return StatusEffect.silence();
      case StatusEffectType.exhaustion:
        return StatusEffect.exhaustion();
    }
  }
}

abstract class BaseSkill {
  final String id;
  final String name;
  final String description;
  final SkillType type;
  final int manaCost;
  final int staminaCost;
  final int cooldown;
  final double damageMultiplier;
  final List<SkillEffect> onHitEffects;
  final bool isAreaDamage;
  final AnimationTrigger animationTrigger;

  int _currentCooldown = 0;

  BaseSkill({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.manaCost = 0,
    this.staminaCost = 0,
    required this.cooldown,
    required this.damageMultiplier,
    this.onHitEffects = const [],
    this.isAreaDamage = false,
    this.animationTrigger = AnimationTrigger.skill,
  });

  bool get isOnCooldown => _currentCooldown > 0;
  int get currentCooldown => _currentCooldown;

  void triggerCooldown() => _currentCooldown = cooldown;
  void tickCooldown() {
    if (_currentCooldown > 0) _currentCooldown--;
  }
  void resetCooldown() => _currentCooldown = 0;

  bool canUse({
    required int currentMana,
    required int currentStamina,
    required bool isSilenced,
    required bool isExhausted,
  }) {
    if (isOnCooldown) return false;
    if (type == SkillType.magic && isSilenced) return false;
    if (type == SkillType.physical && isExhausted) return false;
    if (currentMana < manaCost) return false;
    if (currentStamina < staminaCost) return false;
    return true;
  }

  String get cooldownText => isOnCooldown ? 'CD: $_currentCooldown' : 'Ready';
}
