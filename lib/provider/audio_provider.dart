import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioProvider extends ChangeNotifier {
  final SoLoud _soloud = SoLoud.instance;

  AudioSource? soundSource;
  SoundHandle? handle;

  bool isPlaying = false;
  String activeSide = '';

  double posX = 0;
  double posY = 0;
  double posZ = -1;
  double attenuationDistance = 1;

  double velX = 0;
  double velY = 0;
  double velZ = 0;
  bool dopplerEnabled = false;

  Timer? orbitTimer;
  bool orbitEnabled = false;
  double orbitAngle = 0;

  // Initialize Audio
  Future<void> initializeAudio() async {
    await _soloud.init();
    soundSource = await _soloud.loadAsset('assets/sound/naruto_afternoon.mp3');
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
    if (dopplerEnabled) {
      _soloud.set3dSourceDopplerFactor(handle!, 0);
    }
    await _soloud.stop(handle!);
    stopOrbit();

    handle = null;
    isPlaying = false;
    activeSide = '';
    dopplerEnabled = false;
    debugPrint('🛑 Sound Stopped');
    notifyListeners();
  }

  Future<bool> directSound(String side, double x, double y, double z) async {
    if (handle == null) return false;
    if (!isPlaying) return false;
    if (attenuationDistance == 0) return false;

    if (dopplerEnabled) {
      const dt = 0.04;
      velX = (x - posX) / dt;
      velY = (y - posY) / dt;
      velZ = (z - posZ) / dt;

      _soloud.set3dSourceVelocity(handle!, velX, velY, velZ);
    }

    posX = x;
    posY = y;
    posZ = z;
    _soloud.setVolume(handle!, 0.8);
    _soloud.set3dSourcePosition(handle!, posX, posY, posZ);

    if (!orbitEnabled) {
      activeSide = side;
    }
    notifyListeners();
    return true;
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

  void toggleDoppler() {
    dopplerEnabled = !dopplerEnabled;

    if (handle != null) {
      _soloud.set3dSourceDopplerFactor(handle!, dopplerEnabled ? 1.0 : 0.0);
    }

    notifyListeners();
  }

  void toggleOrbit() {
    orbitEnabled ? stopOrbit() : startOrbit();
  }

  void startOrbit() {
    if (handle == null) return;
    orbitAngle = 0;
    orbitEnabled = true;
    activeSide = '';

    orbitTimer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      orbitAngle += 0.08;

      final x = cos(orbitAngle) * attenuationDistance;
      final z = sin(orbitAngle) * attenuationDistance;

      directSound(activeSide, x, 0, z);
    });
    notifyListeners();
  }

  void stopOrbit() {
    orbitTimer?.cancel();
    orbitTimer = null;

    orbitEnabled = false;
    notifyListeners();
  }

  Future<void> disposeAudio() async {
    stopOrbit();
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
