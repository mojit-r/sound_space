import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioProvider extends ChangeNotifier {
  final SoLoud _soloud = SoLoud.instance;

  AudioSource? soundSource;
  SoundHandle? handle;

  bool isPlaying = false;

  Future<void> initializeAudio() async {
    await _soloud.init();
    soundSource = await _soloud.loadAsset('assets/sound/konoha_peace.mp3');
  }

  Future<void> playSound() async {
    if (soundSource == null) return;
    if (isPlaying) {
      await stopSound();
    }

    handle = await _soloud.play3d(
      soundSource!,
      0.0,
      0.0,
      0.0,
      looping: true,
      loopingStartAt: const Duration(seconds: 1),
    );

    isPlaying = true;
    notifyListeners();
  }

  Future<void> stopSound() async {
    if (handle == null) return;
    await _soloud.stop(handle!);

    handle = null;
    isPlaying = false;
    debugPrint('🛑 Sound Stopped');
    notifyListeners();
  }

  Future<void> directSound(double posX, double posY, double posZ) async {
    if (handle == null) return;

    _soloud.setVolume(handle!, 0.8);
    _soloud.set3dSourcePosition(handle!, posX, posY, posZ);
  }

  Future<void> disposeAudio() async {
    stopSound();
    if (soundSource != null) {
      await _soloud.disposeSource(soundSource!);
    }
    _soloud.deinit();
  }

  @override
  void dispose() {
    disposeAudio();
    super.dispose();
  }
}
