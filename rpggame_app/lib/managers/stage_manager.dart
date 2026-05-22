import '../core/enums.dart';
import '../data/stages_data.dart';
import '../models/character/enemy.dart';
import '../models/character/boss.dart';

class StageManager {
  final List<StageData> _stages = StagsesData.allStages();
  int _currentStageIndex = 0;
  int _currentEncounterIndex = 0;

  int get currentStageIndex => _currentStageIndex;
  int get currentEncounterIndex => _currentEncounterIndex;
  int get totalStages => _stages.length;

  StageData get currentStage => _stages[_currentStageIndex];
  StageArea get currentArea => currentStage.area;

  bool get isAtBoss =>
      _currentEncounterIndex >= currentStage.encounters.length;

  bool get isGameComplete =>
      _currentStageIndex >= _stages.length - 1 &&
      isAtBoss;

  bool get hasNextStage => _currentStageIndex < _stages.length - 1;

  String get currentStageName => currentStage.name;
  String get currentStageSubtitle => currentStage.subtitle;
  String get currentStageDescription => currentStage.description;

  int get encounterNumber => _currentEncounterIndex + 1;
  int get totalEncounters => currentStage.encounters.length;

  // ── Current encounter ─────────────────────────────────────────────────────

  List<Enemy> getCurrentEnemies() {
    if (isAtBoss) return [currentStage.boss.clone() as Enemy];
    final enc = currentStage.encounters[_currentEncounterIndex];
    return enc.enemies.map((e) => e.clone()).toList();
  }

  Boss getCurrentBoss() => currentStage.boss;

  String getCurrentNarration() {
    if (isAtBoss) return 'The boss awaits...';
    return currentStage.encounters[_currentEncounterIndex].narration;
  }

  // ── Progression ───────────────────────────────────────────────────────────

  bool advanceEncounter() {
    if (isAtBoss) return false;
    _currentEncounterIndex++;
    return true;
  }

  bool advanceStage() {
    if (!hasNextStage) return false;
    _currentStageIndex++;
    _currentEncounterIndex = 0;
    return true;
  }

  void resetToStart() {
    _currentStageIndex = 0;
    _currentEncounterIndex = 0;
  }

  void restoreProgress(int stageIdx, int encounterIdx) {
    _currentStageIndex = stageIdx.clamp(0, _stages.length - 1);
    _currentEncounterIndex = encounterIdx.clamp(
        0, _stages[_currentStageIndex].encounters.length);
  }

  bool isStageUnlocked(int stageIdx, int heroLevel) {
    if (stageIdx >= _stages.length) return false;
    return heroLevel >= _stages[stageIdx].requiredLevel;
  }

  // ── Summary ───────────────────────────────────────────────────────────────

  String get progressLabel {
    if (isAtBoss) return '${currentStage.name} — BOSS';
    return '${currentStage.name} — Encounter $encounterNumber/$totalEncounters';
  }

  double get stageProgress {
    final total = totalEncounters + 1; // +1 for boss
    return (_currentEncounterIndex + (isAtBoss ? 1 : 0)) / total;
  }
}
