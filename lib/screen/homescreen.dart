import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_space/provider/audio_provider.dart';
import 'package:sound_space/widgets/circular_button.dart';
import 'package:sound_space/widgets/custom_snackbar.dart';
import 'package:sound_space/widgets/rectangular_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AudioProvider>().initializeAudio();
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    final audio = context.watch<AudioProvider>();

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           SizedBox(height: mq.height * 0.05),
          _upperSection(audio),
          SizedBox(height: mq.height * 0.07),
          _lowerSection(audio),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: audio.isPlaying ? audio.stopSound : audio.playSound,
        backgroundColor: audio.isPlaying
            ? Colors.red.shade300
            : Colors.blue.shade300,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        child: audio.isPlaying
            ? const Icon(Icons.stop)
            : const Icon(Icons.play_arrow),
      ),
    );
  }

  Column _lowerSection(AudioProvider audio) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              color: Colors.green.shade300,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Attenuation(Distance / Volume Fading)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Slider(
                  value: audio.attenuationDistance,
                  min: 0.0,
                  max: 5.0,
                  divisions: 50,
                  label: audio.attenuationDistance.round().toString(),
                  onChanged: (double newValue) {
                    audio.setAttenuationDistance(newValue);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RectangularButton(
              onTap: () {
                audio.toggleDoppler();
              },
              label: 'Doppler Effect',
              icon: Icons.speed_rounded,
              color: Colors.indigo.shade300,
              isEnabled: audio.dopplerEnabled,
            ),
            RectangularButton(
              onTap: () {
                audio.toggleOrbit();
              },
              label: '360° Sound',
              icon: Icons.spatial_audio,
              color: Colors.pink.shade300,
              isEnabled: audio.orbitEnabled,
            ),
          ],
        ),
      ],
    );
  }

  Column _upperSection(AudioProvider audio) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularButton(
          onTap: () async {
            final success = await audio.directSound(
              'top',
              0.0,
              audio.attenuationDistance,
              0.0,
            );
            if (!success && audio.attenuationDistance == 0) {
              _showAttenuationWarning(audio);
            }
            if (audio.orbitEnabled) {
              _show360Warning(audio);
            }
            debugPrint('⬆️ sound playing from the top');
          },
          icon: Icons.keyboard_arrow_up_rounded,
          label: 'Top',
          shadowOffset: const Offset(0, 4),
          isEnabled: audio.activeSide == 'top',
        ),

        const SizedBox(height: 60),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularButton(
              onTap: () async {
                final success = await audio.directSound(
                  'left',
                  -audio.attenuationDistance,
                  0.0,
                  0.0,
                );
                if (!success && audio.attenuationDistance == 0) {
                  _showAttenuationWarning(audio);
                }
                if (audio.orbitEnabled) {
                  _show360Warning(audio);
                }
                debugPrint('⬅️ sound playing from the left');
              },
              icon: Icons.keyboard_arrow_left_rounded,
              label: 'Left',
              shadowOffset: const Offset(4, 0),
              isEnabled: audio.activeSide == 'left',
            ),

            Row(
              children: [
                CircularButton(
                  onTap: () async {
                    final success = await audio.directSound(
                      'front',
                      0.0,
                      0.0,
                      -audio.attenuationDistance,
                    );
                    if (!success && audio.attenuationDistance == 0) {
                      _showAttenuationWarning(audio);
                    }
                    if (audio.orbitEnabled) {
                      _show360Warning(audio);
                    }
                    debugPrint('✋ sound playing from front');
                  },
                  icon: Icons.front_hand_rounded,
                  label: 'front',
                  shadowOffset: const Offset(0, 0),
                  isEnabled: audio.activeSide == 'front',
                  color: Colors.orange,
                  height: 50,
                  width: 50,
                  shadowSpreadRadius: 2,
                ),

                const SizedBox(width: 10),

                CircularButton(
                  onTap: () async {
                    final success = await audio.directSound(
                      'back',
                      0.0,
                      0.0,
                      audio.attenuationDistance,
                    );
                    if (!success && audio.attenuationDistance == 0) {
                      _showAttenuationWarning(audio);
                    }
                    if (audio.orbitEnabled) {
                      _show360Warning(audio);
                    }
                    debugPrint('🤚 sound playing from back');
                  },
                  icon: Icons.back_hand_rounded,
                  label: 'back',
                  shadowOffset: const Offset(0, 0),
                  isEnabled: audio.activeSide == 'back',
                  color: Colors.orange,
                  height: 50,
                  width: 50,
                  shadowSpreadRadius: 2,
                ),
              ],
            ),

            CircularButton(
              onTap: () async {
                final success = await audio.directSound(
                  'right',
                  audio.attenuationDistance,
                  0.0,
                  0.0,
                );
                if (!success && audio.attenuationDistance == 0) {
                  _showAttenuationWarning(audio);
                }
                if (audio.orbitEnabled) {
                  _show360Warning(audio);
                }
                debugPrint('➡️ sound playing from right');
              },
              icon: Icons.keyboard_arrow_right_rounded,
              label: 'Right',
              shadowOffset: const Offset(-4, 0),
              isEnabled: audio.activeSide == 'right',
            ),
          ],
        ),

        const SizedBox(height: 60),

        CircularButton(
          onTap: () async {
            final success = await audio.directSound(
              'bottom',
              0.0,
              -audio.attenuationDistance,
              0.0,
            );
            if (!success && audio.attenuationDistance == 0) {
              _showAttenuationWarning(audio);
            }
            if (audio.orbitEnabled) {
              _show360Warning(audio);
            }
            debugPrint('⬇️ sound playing from bottom');
          },
          icon: Icons.keyboard_arrow_down_rounded,
          label: 'Bottom',
          shadowOffset: const Offset(0, -4),
          isEnabled: audio.activeSide == 'bottom',
        ),
      ],
    );
  }

  void _showAttenuationWarning(AudioProvider audio) {
    if (!audio.isPlaying) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    CustomSnackbar.show(context, 'Attenuation should not be zero');
  }

  void _show360Warning(AudioProvider audio) {
    if (!audio.isPlaying) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    CustomSnackbar.show(context, '360° Sound is Playing');
  }
}
