import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;

  bool get isMusicEnabled => _isMusicEnabled;

  // Background music file
  static const String bgMusic = 'audio/bgm.mp3';
  
  // SFX placeholders (will work when files are added)
  // static const String sfxCorrect = 'audio/correct.mp3';
  // static const String sfxWrong = 'audio/wrong.mp3';
  // static const String sfxClick = 'audio/click.mp3';
  // static const String sfxWin = 'audio/win.mp3';

  Future<void> init() async {
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      // Preload standard SFX if needed
    } catch (e) {
      debugPrint('Error initializing AudioService: $e');
    }
  }

  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled) return;
    
    try {
      if (_musicPlayer.state != PlayerState.playing) {
        await _musicPlayer.play(AssetSource(bgMusic));
        await _musicPlayer.setVolume(1.0); // 100% volume for background
      }
    } catch (e) {
      debugPrint('Error playing background music: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    try {
      await _musicPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping background music: $e');
    }
  }

  Future<void> toggleMusic() async {
    _isMusicEnabled = !_isMusicEnabled;
    if (_isMusicEnabled) {
      await playBackgroundMusic();
    } else {
      await stopBackgroundMusic();
    }
  }

  Future<void> playSfx(String fileName) async {
    if (!_isSfxEnabled) return;

    try {
      // Create a new player for overlapping SFX or use a pool if needed
      // For simple keys, one player might be enough or we create disposable ones
      final player = AudioPlayer();
      await player.play(AssetSource(fileName));
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (e) {
      debugPrint('Error playing SFX ($fileName): $e');
    }
  }
  
  // Helpers for common game sounds
  Future<void> playCorrectSound() async {
    // await playSfx(sfxCorrect);
  } 
  Future<void> playWrongSound() async {
    // await playSfx(sfxWrong);
  }
  Future<void> playClickSound() async {
    // await playSfx(sfxClick);
  }
  Future<void> playWinSound() async {
    // await playSfx(sfxWin);
  }
}
