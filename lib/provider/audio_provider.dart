import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioProvider extends ChangeNotifier {
  final SoLoud _soloud = SoLoud.instance;

  AudioSource? soundSource;
  SoundHandle? handle;

  bool isPlaying = false;
  double posX = 0;
  double posY = 0;
  double posZ = -1;
  double attenuationDistance = 1;

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
      posX,
      posY,
      posZ,
      looping: true,
      loopingStartAt: const Duration(seconds: 1),
    );

    _soloud.set3dSourceMinMaxDistance(handle!, 1, 5);

    _soloud.set3dSourceAttenuation(handle!, 1, 1.0);

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

  Future<void> directSound(double x, double y, double z) async {
    if (handle == null) return;

    posX = x;
    posY = y;
    posZ = z;

    _soloud.setVolume(handle!, 0.8);
    _soloud.set3dSourcePosition(handle!, posX, posY, posZ);
  }

  void setAttenuationDistance(double value) {
    attenuationDistance = value;

    if (handle != null) {
      _soloud.set3dSourcePosition(
        handle!,
        posX == 0 ? 0 : posX.sign * attenuationDistance,
        posY == 0 ? 0 : posY.sign * attenuationDistance,
        posZ == 0 ? 0 : posZ.sign * attenuationDistance,
      );
    }

    notifyListeners();
  }

  Future<void> disposeAudio() async {
    await stopSound();
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
