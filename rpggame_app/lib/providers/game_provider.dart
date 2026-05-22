import 'package:flutter/foundation.dart';
import '../core/enums.dart';
import '../core/game_events.dart';
import '../models/character/hero.dart';
import '../models/character/enemy.dart';
import '../models/items/consumable.dart';
import '../models/items/equipment.dart';
import '../managers/combat_manager.dart';
import '../managers/inventory_manager.dart';
import '../managers/loot_manager.dart';
import '../managers/save_manager.dart';
import '../managers/stage_manager.dart';
import '../managers/story_manager.dart';
import '../managers/audio_manager.dart';
import '../data/heroes_data.dart';

enum GameScreen {
  mainMenu,
  characterSelect,
  stageMap,
  battle,
  victory,
  defeat,
  inventory,
  equipment,
  skillTree,
  shop,
  settings,
}

class GameProvider extends ChangeNotifier {
  // Managers
  final CombatManager _combat = CombatManager();
  final InventoryManager _inventory = InventoryManager();
  final StageManager _stage = StageManager();
  final StoryManager _story = StoryManager();
  final AudioManager _audio = AudioManager();
  final SaveManager _save = SaveManager();

  Hero? _hero;
  GameScreen _screen = GameScreen.mainMenu;
  LootResult? _lastLoot;
  bool _debugMode = false;
  bool _isLoading = false;
  String? _errorMessage;

  // ── Public accessors ──────────────────────────────────────────────────────

  Hero? get hero => _hero;
  GameScreen get screen => _screen;
  CombatManager get combat => _combat;
  InventoryManager get inventory => _inventory;
  StageManager get stage => _stage;
  StoryManager get story => _story;
  AudioManager get audio => _audio;
  LootResult? get lastLoot => _lastLoot;
  bool get debugMode => _debugMode;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasSaveGame => _hero != null;

  // ── Game start / load ─────────────────────────────────────────────────────

  void selectHero(CharacterClass cls) {
    _hero = HeroesData.all().firstWhere((h) => h.characterClass == cls);
    _audio.playButtonClick();
    _goTo(GameScreen.stageMap);
    _story.startOpening();
  }

  Future<void> loadGame() async {
    _setLoading(true);
    try {
      final data = await _save.loadGame();
      if (data != null) {
        _hero = data.hero;
        _inventory.loadItems(data.inventory);
        _stage.restoreProgress(data.currentStageIndex, data.currentEncounterIndex);
        _debugMode = data.debugMode;
        _goTo(GameScreen.stageMap);
      }
    } catch (e) {
      _errorMessage = 'Failed to load save: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveGame() async {
    if (_hero == null) return;
    await _save.saveGame(SaveData(
      hero: _hero!,
      inventory: _inventory.items.toList(),
      currentStageIndex: _stage.currentStageIndex,
      currentEncounterIndex: _stage.currentEncounterIndex,
      debugMode: _debugMode,
    ));
  }

  Future<bool> hasSave() => _save.hasSaveFile();

  Future<void> deleteSave() async {
    await _save.deleteSave();
    _hero = null;
    _inventory.clear();
    _stage.resetToStart();
    notifyListeners();
  }

  // ── Battle flow ───────────────────────────────────────────────────────────

  void startNextBattle() {
    if (_hero == null) return;
    final enemies = _stage.getCurrentEnemies();
    _combat.initBattle(_hero!, enemies);
    _audio.playBattleMusic();
    _goTo(GameScreen.battle);
  }

  void startBossBattle() {
    if (_hero == null) return;
    final boss = _stage.getCurrentBoss();
    _combat.initBattle(_hero!, [boss]);
    _audio.playBossMusic();
    _story.startBossIntro(boss.id);
    _goTo(GameScreen.battle);
  }

  // Combat action delegation (each notifies listeners)

  void doAttack() {
    _combat.playerAttack();
    _audio.playSwordHit();
    _postAction();
  }

  void doSkill(int index) {
    _combat.playerUseSkill(index);
    _audio.playMagicCast();
    _postAction();
  }

  void doDefend() {
    _combat.playerDefend();
    _postAction();
  }

  void doUseItem(Consumable item) {
    if (!_inventory.hasItem(item.id)) return;
    _combat.playerUseItem(item);
    _inventory.removeItemByRef(item);
    _postAction();
  }

  void doEscape() {
    final escaped = _combat.playerEscape();
    if (escaped) {
      _goTo(GameScreen.stageMap);
    }
    notifyListeners();
  }

  // Enemy takes its turn (called from UI after player action resolves)
  void triggerEnemyTurn() {
    if (_combat.state != CombatState.enemyTurn) return;
    _combat.processEnemyTurn();
    _postAction();
  }

  void _postAction() {
    notifyListeners();
    if (_combat.isOver) _handleBattleEnd();
  }

  void _handleBattleEnd() {
    if (_combat.state == CombatState.victory) {
      _lastLoot = _combat.generateLoot(_stage.currentArea);
      final hero = _hero!;

      // Apply rewards
      hero.earnGold(_lastLoot!.gold);
      final leveledUp = hero.gainXp(_lastLoot!.xp);
      for (final item in _lastLoot!.items) {
        _inventory.addItem(item);
      }

      if (leveledUp) _audio.playLevelUp();
      _audio.playVictoryMusic();
      _stage.advanceEncounter();
      _goTo(GameScreen.victory);
      saveGame();
    } else if (_combat.state == CombatState.defeat) {
      _audio.playDefeatMusic();
      _goTo(GameScreen.defeat);
    }
  }

  // ── Navigation helpers ────────────────────────────────────────────────────

  void goToCharacterSelect() => _goTo(GameScreen.characterSelect);
  void goToShop() => _goTo(GameScreen.shop);
  void goToInventory() => _goTo(GameScreen.inventory);
  void goToEquipment() => _goTo(GameScreen.equipment);
  void goToSkillTree() => _goTo(GameScreen.skillTree);
  void goToSettings() => _goTo(GameScreen.settings);
  void goToStageMap() => _goTo(GameScreen.stageMap);
  void goToMainMenu() {
    saveGame();
    _goTo(GameScreen.mainMenu);
  }

  void retryBattle() {
    _hero!.currentHp = _hero!.maxHp;
    _hero!.currentMp = _hero!.maxMp;
    _hero!.currentSp = _hero!.maxSp;
    _hero!.clearAllEffects();
    startNextBattle();
  }

  void _goTo(GameScreen s) {
    _screen = s;
    notifyListeners();
  }

  // ── Shop ──────────────────────────────────────────────────────────────────

  bool buyItem(dynamic item) {
    if (_hero == null) return false;
    if (!_hero!.spendGold(item.buyPrice)) return false;
    _inventory.addItem(item);
    _audio.playItemPickup();
    notifyListeners();
    return true;
  }

  bool sellItem(dynamic item) {
    if (_hero == null) return false;
    if (!_inventory.removeItemByRef(item)) return false;
    _hero!.earnGold(item.sellPrice);
    notifyListeners();
    return true;
  }

  // ── Equipment ─────────────────────────────────────────────────────────────

  void equipItem(Equipment item) {
    if (_hero == null) return;
    final old = _hero!.equipped[item.slot];
    if (old != null) _inventory.addItem(old);
    _inventory.removeItemByRef(item);
    _hero!.equip(item);
    notifyListeners();
  }

  void unequipSlot(EquipmentSlot slot) {
    if (_hero == null) return;
    final item = _hero!.equipped[slot];
    _hero!.unequip(slot);
    if (item != null) _inventory.addItem(item);
    notifyListeners();
  }

  // ── Settings ──────────────────────────────────────────────────────────────

  Future<void> loadSettings() async {
    final settings = await _save.loadSettings();
    _audio.setMusicEnabled(settings['musicEnabled'] as bool? ?? true);
    _audio.setSfxEnabled(settings['sfxEnabled'] as bool? ?? true);
    _audio.setMusicVolume((settings['musicVolume'] as num?)?.toDouble() ?? 0.7);
    _audio.setSfxVolume((settings['sfxVolume'] as num?)?.toDouble() ?? 1.0);
    _debugMode = settings['debugMode'] as bool? ?? false;
    notifyListeners();
  }

  Future<void> applySettings({
    bool? musicEnabled,
    bool? sfxEnabled,
    double? musicVolume,
    double? sfxVolume,
    bool? debugMode,
  }) async {
    if (musicEnabled != null) _audio.setMusicEnabled(musicEnabled);
    if (sfxEnabled != null) _audio.setSfxEnabled(sfxEnabled);
    if (musicVolume != null) _audio.setMusicVolume(musicVolume);
    if (sfxVolume != null) _audio.setSfxVolume(sfxVolume);
    if (debugMode != null) _debugMode = debugMode;
    await _save.saveSettings(
      musicEnabled: _audio.musicEnabled,
      sfxEnabled: _audio.sfxEnabled,
      musicVolume: _audio.musicVolume,
      sfxVolume: _audio.sfxVolume,
      debugMode: _debugMode,
    );
    notifyListeners();
  }

  // ── Utility ───────────────────────────────────────────────────────────────

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
