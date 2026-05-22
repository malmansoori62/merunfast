import 'enums.dart';

abstract class GameEvent {
  final DateTime timestamp;
  GameEvent() : timestamp = DateTime.now();
}

class CombatLogEntry {
  final String message;
  final LogType type;
  final AnimationTrigger? animation;
  final DateTime timestamp;

  CombatLogEntry({
    required this.message,
    this.type = LogType.combat,
    this.animation,
  }) : timestamp = DateTime.now();
}

class DamageResult {
  final int rawDamage;
  final int finalDamage;
  final bool isCritical;
  final bool isDodged;
  final DamageType damageType;
  final String attackerName;
  final String defenderName;

  const DamageResult({
    required this.rawDamage,
    required this.finalDamage,
    required this.isCritical,
    required this.isDodged,
    required this.damageType,
    required this.attackerName,
    required this.defenderName,
  });

  CombatLogEntry toLogEntry() {
    if (isDodged) {
      return CombatLogEntry(
        message: '$defenderName dodged the attack!',
        animation: AnimationTrigger.defend,
      );
    }
    final critTag = isCritical ? ' ★ CRITICAL' : '';
    return CombatLogEntry(
      message: '$attackerName → $finalDamage dmg to $defenderName$critTag',
      animation: isCritical ? AnimationTrigger.criticalHit : AnimationTrigger.takeDamage,
    );
  }
}

class SkillUseResult {
  final String casterName;
  final String skillName;
  final bool success;
  final String? failReason;

  const SkillUseResult({
    required this.casterName,
    required this.skillName,
    required this.success,
    this.failReason,
  });

  CombatLogEntry toLogEntry() {
    if (!success) {
      return CombatLogEntry(
        message: '$casterName cannot use $skillName! ${failReason ?? ''}',
        type: LogType.system,
      );
    }
    return CombatLogEntry(
      message: '$casterName used $skillName!',
      animation: AnimationTrigger.skill,
    );
  }
}

class BattleResult {
  final bool isVictory;
  final int goldEarned;
  final int xpEarned;
  final List<String> lootNames;

  const BattleResult({
    required this.isVictory,
    required this.goldEarned,
    required this.xpEarned,
    required this.lootNames,
  });
}
