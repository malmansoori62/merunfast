// AudioManager manages music and SFX playback.
// Asset files should be placed under assets/audio/ when added.
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  double _musicVolume = 0.7;
  double _sfxVolume = 1.0;
  String? _currentTrack;

  bool get musicEnabled => _musicEnabled;
  bool get sfxEnabled => _sfxEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) stopMusic();
  }

  void setSfxEnabled(bool enabled) => _sfxEnabled = enabled;

  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    // Update current track volume when audioplayers is wired up
  }

  void setSfxVolume(double volume) => _sfxVolume = volume.clamp(0.0, 1.0);

  void playMusic(String trackId) {
    if (!_musicEnabled) return;
    if (_currentTrack == trackId) return;
    _currentTrack = trackId;
    // audioplayers integration: AudioPlayer().play(AssetSource('audio/$trackId.mp3'))
  }

  void stopMusic() {
    _currentTrack = null;
    // audioplayers: player.stop()
  }

  void playSfx(String sfxId) {
    if (!_sfxEnabled) return;
    // audioplayers: AudioPlayer().play(AssetSource('audio/sfx/$sfxId.mp3'))
  }

  // ── Named tracks ──────────────────────────────────────────────────────────

  void playMainMenuMusic() => playMusic('main_theme');
  void playBattleMusic() => playMusic('battle_theme');
  void playBossMusic() => playMusic('boss_theme');
  void playVictoryMusic() => playMusic('victory_fanfare');
  void playDefeatMusic() => playMusic('defeat_sting');

  void playSwordHit() => playSfx('sword_hit');
  void playMagicCast() => playSfx('magic_cast');
  void playCriticalHit() => playSfx('critical_hit');
  void playLevelUp() => playSfx('level_up');
  void playItemPickup() => playSfx('item_pickup');
  void playButtonClick() => playSfx('button_click');
  void playBossRoar() => playSfx('boss_roar');
  void playDeathSound() => playSfx('death_sound');
}
