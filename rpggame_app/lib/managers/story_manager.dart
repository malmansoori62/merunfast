import '../core/enums.dart';
import '../data/story_data.dart';

class StoryManager {
  int _dialogueIndex = 0;
  List<StoryLine> _currentLines = [];
  bool _isDisplaying = false;

  bool get isDisplaying => _isDisplaying;
  bool get hasMore => _dialogueIndex < _currentLines.length;

  StoryLine? get currentLine =>
      _dialogueIndex < _currentLines.length ? _currentLines[_dialogueIndex] : null;

  void startDialogue(List<StoryLine> lines) {
    _currentLines = lines;
    _dialogueIndex = 0;
    _isDisplaying = lines.isNotEmpty;
  }

  void startOpening() => startDialogue(StoryData.opening);

  void startStageIntro(StageArea area) {
    final lines = StoryData.stageIntros[area] ?? [];
    startDialogue(lines);
  }

  void startBossIntro(String bossId) {
    final lines = StoryData.bossIntros[bossId] ?? [];
    startDialogue(lines);
  }

  StoryLine? advance() {
    if (!hasMore) {
      _isDisplaying = false;
      return null;
    }
    final line = _currentLines[_dialogueIndex];
    _dialogueIndex++;
    if (_dialogueIndex >= _currentLines.length) _isDisplaying = false;
    return line;
  }

  void skipAll() {
    _dialogueIndex = _currentLines.length;
    _isDisplaying = false;
  }

  void reset() {
    _currentLines = [];
    _dialogueIndex = 0;
    _isDisplaying = false;
  }

  String getVictoryNarration(StageArea area) =>
      StoryData.stageVictory[area] ?? 'Victory!';

  String getRandomShopGreeting() {
    final idx = DateTime.now().millisecondsSinceEpoch %
        StoryData.shopGreetings.length;
    return StoryData.shopGreetings[idx];
  }

  String getRandomRestDialogue() {
    final idx = DateTime.now().millisecondsSinceEpoch %
        StoryData.restDialogue.length;
    return StoryData.restDialogue[idx];
  }
}
