import '../core/enums.dart';
import '../core/constants.dart';

class StatusEffect {
  final StatusEffectType type;
  int duration;
  int stacks;
  final int tickDamage;
  final double statMultiplier;
  int shieldHp;

  StatusEffect({
    required this.type,
    int? duration,
    this.stacks = 1,
    this.tickDamage = 0,
    this.statMultiplier = 1.0,
    this.shieldHp = 0,
  }) : duration = duration ?? (GameConstants.defaultStatusDurations[type] ?? 2);

  bool get isExpired => duration <= 0;
  bool get isDoT => tickDamage > 0;

  bool get preventsPhysical =>
      type == StatusEffectType.stun ||
      type == StatusEffectType.freeze ||
      type == StatusEffectType.exhaustion;

  bool get preventsMagic =>
      type == StatusEffectType.stun ||
      type == StatusEffectType.freeze ||
      type == StatusEffectType.silence;

  bool get skipsTurn =>
      type == StatusEffectType.stun || type == StatusEffectType.freeze;

  void tick() {
    if (duration > 0) duration--;
  }

  bool tryAddStack() {
    final max = GameConstants.maxStatusStacks[type] ?? 1;
    if (stacks < max) {
      stacks++;
      duration = GameConstants.defaultStatusDurations[type] ?? 2;
      return true;
    }
    return false;
  }

  int getTickDamage() => tickDamage * stacks;

  int absorbDamage(int incoming) {
    if (type != StatusEffectType.shield || shieldHp <= 0) return incoming;
    if (shieldHp >= incoming) {
      shieldHp -= incoming;
      if (shieldHp <= 0) duration = 0;
      return 0;
    }
    final remaining = incoming - shieldHp;
    shieldHp = 0;
    duration = 0;
    return remaining;
  }

  String get displayName {
    switch (type) {
      case StatusEffectType.bleed: return 'Bleeding';
      case StatusEffectType.burn: return 'Burning';
      case StatusEffectType.poison: return 'Poisoned';
      case StatusEffectType.stun: return 'Stunned';
      case StatusEffectType.freeze: return 'Frozen';
      case StatusEffectType.weakness: return 'Weakened';
      case StatusEffectType.rage: return 'Enraged';
      case StatusEffectType.shield: return 'Shielded';
      case StatusEffectType.silence: return 'Silenced';
      case StatusEffectType.exhaustion: return 'Exhausted';
    }
  }

  static StatusEffect bleed({int damage = 8}) =>
      StatusEffect(type: StatusEffectType.bleed, tickDamage: damage);

  static StatusEffect burn({int damage = 14}) =>
      StatusEffect(type: StatusEffectType.burn, tickDamage: damage);

  static StatusEffect poison({int damage = 6}) =>
      StatusEffect(type: StatusEffectType.poison, tickDamage: damage);

  static StatusEffect stun() =>
      StatusEffect(type: StatusEffectType.stun);

  static StatusEffect freeze() =>
      StatusEffect(type: StatusEffectType.freeze);

  static StatusEffect weakness() =>
      StatusEffect(type: StatusEffectType.weakness, statMultiplier: 0.70);

  static StatusEffect rage() =>
      StatusEffect(type: StatusEffectType.rage, statMultiplier: 1.35);

  static StatusEffect shield({int hp = 40}) =>
      StatusEffect(type: StatusEffectType.shield, shieldHp: hp);

  static StatusEffect silence() =>
      StatusEffect(type: StatusEffectType.silence);

  static StatusEffect exhaustion() =>
      StatusEffect(type: StatusEffectType.exhaustion, statMultiplier: 0.50);

  StatusEffect clone() => StatusEffect(
        type: type,
        duration: duration,
        stacks: stacks,
        tickDamage: tickDamage,
        statMultiplier: statMultiplier,
        shieldHp: shieldHp,
      );
}
