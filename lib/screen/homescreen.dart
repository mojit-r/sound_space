import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:sound_space/widgets/sound_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SoLoud? soloud;
  AudioSource? soundSource;
  SoundHandle? handle;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  @override
  void dispose() {
    _disposeAudio();
    super.dispose();
  }

  Future<void> _initializeAudio() async {
    soloud = SoLoud.instance;
    await soloud?.init();

    soundSource = await soloud?.loadAsset('assets/sound/konoha_peace.mp3');
  }

  Future<void> _disposeAudio() async {
    _stopSound();
    await soloud?.disposeSource(soundSource!);
    soloud?.deinit();
  }

  Future<void> _playSound() async {
    if (isPlaying) {
      await _stopSound();
    }

    handle = await soloud?.play3d(
      soundSource!,
      0.0,
      0.0,
      0.0,
      looping: true,
      loopingStartAt: const Duration(seconds: 1),
    );

    if (!mounted) return;
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> _directSound(double posX, posY, posZ) async {
    if (handle == null) return;

    soloud?.setVolume(handle!, 0.8);
    soloud?.set3dSourcePosition(handle!, posX, posY, posZ);
  }

  Future<void> _stopSound() async {
    // soloud.pauseSwitch(handle);
    await soloud?.stop(handle!);
    if (!mounted) return;
    setState(() {
      isPlaying = false;
    });
    debugPrint('🛑 Sound Stopped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'S O U N D',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          soundButton(
            onTap: () {
              _directSound(0.0, 5.0, 0.0);
              debugPrint('⬆️ sound playing from the top');
            },
            icon: Icons.keyboard_arrow_up_rounded,
            shadowOffset: const Offset(0, 4),
          ),

          const SizedBox(height: 60),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              soundButton(
                onTap: () {
                  _directSound(-5.0, 0.0, 0.0);
                  debugPrint('⬅️ sound playing from the left');
                },
                icon: Icons.keyboard_arrow_left_rounded,
                shadowOffset: const Offset(4, 0),
              ),

              Row(
                children: [
                  soundButton(
                    onTap: () {
                      _directSound(0.0, 0.0, -5.0);
                      debugPrint('✋ sound playing from front');
                    },
                    icon: Icons.front_hand_rounded,
                    shadowOffset: const Offset(0, 0),
                    color: Colors.orange,
                    height: 50,
                    width: 50,
                    shadowSpreadRadius: 2,
                  ),

                  const SizedBox(width: 10),

                  soundButton(
                    onTap: () {
                      _directSound(0.0, 0.0, 5.0);
                      debugPrint('🤚 sound playing from back');
                    },
                    icon: Icons.back_hand_rounded,
                    shadowOffset: const Offset(0, 0),
                    color: Colors.orange,
                    height: 50,
                    width: 50,
                    shadowSpreadRadius: 2,
                  ),
                ],
              ),

              soundButton(
                onTap: () {
                  _directSound(5.0, 0.0, 0.0);
                  debugPrint('➡️ sound playing from right');
                },
                icon: Icons.keyboard_arrow_right_rounded,
                shadowOffset: const Offset(-4, 0),
              ),
            ],
          ),

          const SizedBox(height: 60),

          soundButton(
            onTap: () {
              _directSound(0.0, -5.0, 0.0);
              debugPrint('⬇️ sound playing from bottom');
            },
            icon: Icons.keyboard_arrow_down_rounded,
            shadowOffset: const Offset(0, -4),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: isPlaying ? _stopSound : _playSound,
        backgroundColor: isPlaying ? Colors.red.shade300 : Colors.blue.shade300,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        child: isPlaying
            ? const Icon(Icons.stop)
            : const Icon(Icons.play_arrow),
      ),
    );
  }
}
