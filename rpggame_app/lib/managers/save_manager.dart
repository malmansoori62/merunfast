import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character/hero.dart';
import '../models/items/base_item.dart';
import '../models/items/equipment.dart';
import '../models/items/consumable.dart';
import '../core/enums.dart';
import '../data/heroes_data.dart';
import '../data/items_data.dart';

class SaveData {
  final Hero hero;
  final List<dynamic> inventory;
  final int currentStageIndex;
  final int currentEncounterIndex;
  final bool debugMode;

  const SaveData({
    required this.hero,
    required this.inventory,
    required this.currentStageIndex,
    required this.currentEncounterIndex,
    this.debugMode = false,
  });
}

class SaveManager {
  static const String _saveKey = 'rpggame_save';
  static const String _settingsKey = 'rpggame_settings';

  Future<void> saveGame(SaveData data) async {
    final prefs = await SharedPreferences.getInstance();
    final json = _encodeGame(data);
    await prefs.setString(_saveKey, jsonEncode(json));
  }

  Future<SaveData?> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_saveKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return _decodeGame(json);
    } catch (_) {
      return null;
    }
  }

  Future<bool> hasSaveFile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_saveKey);
  }

  Future<void> deleteSave() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_saveKey);
  }

  Future<void> saveSettings({
    required bool musicEnabled,
    required bool sfxEnabled,
    required double musicVolume,
    required double sfxVolume,
    required bool debugMode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode({
      'musicEnabled': musicEnabled,
      'sfxEnabled': sfxEnabled,
      'musicVolume': musicVolume,
      'sfxVolume': sfxVolume,
      'debugMode': debugMode,
    }));
  }

  Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null) {
      return {
        'musicEnabled': true,
        'sfxEnabled': true,
        'musicVolume': 0.7,
        'sfxVolume': 1.0,
        'debugMode': false,
      };
    }
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  // ── Encoding ──────────────────────────────────────────────────────────────

  Map<String, dynamic> _encodeGame(SaveData data) {
    return {
      'hero': data.hero.toJson(),
      'inventory': data.inventory.map((item) {
        if (item is Equipment) return {'type': 'equipment', ...item.toJson()};
        if (item is Consumable) return {'type': 'consumable', ...item.toJson()};
        return null;
      }).where((e) => e != null).toList(),
      'currentStageIndex': data.currentStageIndex,
      'currentEncounterIndex': data.currentEncounterIndex,
      'debugMode': data.debugMode,
    };
  }

  SaveData _decodeGame(Map<String, dynamic> json) {
    final heroJson = json['hero'] as Map<String, dynamic>;
    final base = HeroesData.byId(heroJson['id'] as String);

    base.level = heroJson['level'] as int? ?? 1;
    base.currentXp = heroJson['currentXp'] as int? ?? 0;
    base.gold = heroJson['gold'] as int? ?? 100;
    base.availableStatPoints = heroJson['availableStatPoints'] as int? ?? 0;
    base.currentHp = heroJson['currentHp'] as int? ?? base.maxHp;
    base.currentMp = heroJson['currentMp'] as int? ?? base.maxMp;
    base.currentSp = heroJson['currentSp'] as int? ?? base.maxSp;
    base.baseMaxHp = heroJson['baseMaxHp'] as int? ?? base.baseMaxHp;
    base.baseMaxMp = heroJson['baseMaxMp'] as int? ?? base.baseMaxMp;
    base.baseMaxSp = heroJson['baseMaxSp'] as int? ?? base.baseMaxSp;
    base.baseStr = heroJson['baseStr'] as int? ?? base.baseStr;
    base.baseAgi = heroJson['baseAgi'] as int? ?? base.baseAgi;
    base.baseInt = heroJson['baseInt'] as int? ?? base.baseInt;
    base.baseCon = heroJson['baseCon'] as int? ?? base.baseCon;
    base.baseDef = heroJson['baseDef'] as int? ?? base.baseDef;
    base.baseMdef = heroJson['baseMdef'] as int? ?? base.baseMdef;

    final inventoryRaw = json['inventory'] as List<dynamic>? ?? [];
    final inventory = <dynamic>[];
    for (final raw in inventoryRaw) {
      final map = raw as Map<String, dynamic>;
      final item = ItemsData.build(map['id'] as String);
      if (item == null) continue;
      if (item is Consumable) {
        item.quantity = map['quantity'] as int? ?? 1;
      }
      inventory.add(item);
    }

    // Restore equipped items
    final equippedJson = heroJson['equipped'] as Map<String, dynamic>? ?? {};
    for (final entry in equippedJson.entries) {
      final slot = EquipmentSlot.values.firstWhere(
        (s) => s.name == entry.key,
        orElse: () => EquipmentSlot.weapon,
      );
      final item = ItemsData.build(entry.value as String);
      if (item is Equipment) base.equip(item);
    }

    return SaveData(
      hero: base,
      inventory: inventory,
      currentStageIndex: json['currentStageIndex'] as int? ?? 0,
      currentEncounterIndex: json['currentEncounterIndex'] as int? ?? 0,
      debugMode: json['debugMode'] as bool? ?? false,
    );
  }
}
