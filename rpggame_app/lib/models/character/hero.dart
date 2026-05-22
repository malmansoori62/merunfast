import '../../core/enums.dart';
import '../../core/constants.dart';
import '../skills/base_skill.dart';
import '../items/equipment.dart';
import '../items/consumable.dart';
import 'base_character.dart';

class Hero extends BaseCharacter {
  int level;
  int currentXp;
  int gold;
  int availableStatPoints;
  final Map<EquipmentSlot, Equipment?> equipped;

  Hero({
    required super.id,
    required super.name,
    required super.characterClass,
    required super.baseMaxHp,
    required super.baseMaxMp,
    required super.baseMaxSp,
    required super.baseStr,
    required super.baseAgi,
    required super.baseInt,
    required super.baseCon,
    required super.baseDef,
    required super.baseMdef,
    required super.baseCritChance,
    required super.baseCritDamage,
    required super.baseDodgeChance,
    required super.baseAccuracy,
    required super.baseSpeed,
    List<BaseSkill>? skills,
    this.level = 1,
    this.currentXp = 0,
    this.gold = 100,
    this.availableStatPoints = 0,
  })  : equipped = {
          EquipmentSlot.weapon: null,
          EquipmentSlot.armor: null,
          EquipmentSlot.ring: null,
          EquipmentSlot.amulet: null,
          EquipmentSlot.shield: null,
        },
        super(skills: skills);

  int get xpToNextLevel => GameConstants.xpRequired(level + 1);
  double get xpProgress =>
      level >= GameConstants.maxLevel ? 1.0 : currentXp / xpToNextLevel;

  bool gainXp(int amount) {
    if (level >= GameConstants.maxLevel) return false;
    currentXp += amount;
    if (currentXp >= xpToNextLevel) {
      currentXp -= xpToNextLevel;
      _levelUp();
      return true;
    }
    return false;
  }

  void _levelUp() {
    level++;
    availableStatPoints += GameConstants.statPointsPerLevel;
    final growth = GameConstants.levelStatGrowth[characterClass]!;
    baseMaxHp += growth['hp']!;
    baseMaxMp += growth['mp']!;
    baseMaxSp += growth['sp']!;
    baseStr += growth['str']!;
    baseAgi += growth['agi']!;
    baseInt += growth['int']!;
    baseCon += growth['con']!;
    baseDef += growth['def']!;
    baseMdef += growth['mdef']!;
    // Restore resources on level up
    currentHp = maxHp;
    currentMp = maxMp;
    currentSp = maxSp;
  }

  void spendStatPoint(String stat) {
    if (availableStatPoints <= 0) return;
    availableStatPoints--;
    switch (stat) {
      case 'str': baseStr += 2; break;
      case 'agi': baseAgi += 2; break;
      case 'int': baseInt += 2; break;
      case 'con': baseCon += 2; baseMaxHp += 10; break;
      case 'def': baseDef += 2; break;
      case 'mdef': baseMdef += 2; break;
    }
  }

  void equip(Equipment item) {
    equipped[item.slot] = item;
    _refreshEquipmentBonuses();
  }

  void unequip(EquipmentSlot slot) {
    equipped[slot] = null;
    _refreshEquipmentBonuses();
  }

  void _refreshEquipmentBonuses() {
    applyEquipmentBonuses(equipped.values.toList());
  }

  void earnGold(int amount) => gold += amount;
  bool spendGold(int amount) {
    if (gold < amount) return false;
    gold -= amount;
    return true;
  }

  String get classLabel {
    switch (characterClass) {
      case CharacterClass.warrior: return 'Warrior';
      case CharacterClass.rogue: return 'Rogue';
      case CharacterClass.mage: return 'Mage';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'class': characterClass.name,
        'level': level,
        'currentXp': currentXp,
        'gold': gold,
        'availableStatPoints': availableStatPoints,
        'currentHp': currentHp,
        'currentMp': currentMp,
        'currentSp': currentSp,
        'baseMaxHp': baseMaxHp,
        'baseMaxMp': baseMaxMp,
        'baseMaxSp': baseMaxSp,
        'baseStr': baseStr,
        'baseAgi': baseAgi,
        'baseInt': baseInt,
        'baseCon': baseCon,
        'baseDef': baseDef,
        'baseMdef': baseMdef,
        'equipped': {
          for (final e in equipped.entries)
            if (e.value != null) e.key.name: e.value!.id,
        },
      };
}
