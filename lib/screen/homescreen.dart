import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_space/provider/audio_provider.dart';
import 'package:sound_space/widgets/circular_button.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _upperSection(audio),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blueGrey.shade300,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Attenuation(Distance / Volume Fading)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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
                    onTap: () {},
                    label: 'Doppler Effect',
                    icon: Icons.speed_rounded,
                    color: Colors.green.shade300,
                  ),
                  RectangularButton(
                    onTap: () {},
                    label: 'Spatial calc.',
                    icon: Icons.social_distance_rounded,
                    color: Colors.pink.shade300,
                  ),
                ],
              ),
            ],
          ),
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

  Column _upperSection(AudioProvider audio) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularButton(
          onTap: () {
            audio.directSound(0.0, audio.attenuationDistance, 0.0);
            debugPrint('⬆️ sound playing from the top');
          },
          icon: Icons.keyboard_arrow_up_rounded,
          label: 'Top',
          shadowOffset: const Offset(0, 4),
        ),

        const SizedBox(height: 60),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularButton(
              onTap: () {
                audio.directSound(-audio.attenuationDistance, 0.0, 0.0);
                debugPrint('⬅️ sound playing from the left');
              },
              icon: Icons.keyboard_arrow_left_rounded,
              label: 'Left',
              shadowOffset: const Offset(4, 0),
            ),

            Row(
              children: [
                CircularButton(
                  onTap: () {
                    audio.directSound(0.0, 0.0, -audio.attenuationDistance);
                    debugPrint('✋ sound playing from front');
                  },
                  icon: Icons.front_hand_rounded,
                  label: 'front',
                  shadowOffset: const Offset(0, 0),
                  color: Colors.orange,
                  height: 50,
                  width: 50,
                  shadowSpreadRadius: 2,
                ),

                const SizedBox(width: 10),

                CircularButton(
                  onTap: () {
                    audio.directSound(0.0, 0.0, audio.attenuationDistance);
                    debugPrint('🤚 sound playing from back');
                  },
                  icon: Icons.back_hand_rounded,
                  label: 'back',
                  shadowOffset: const Offset(0, 0),
                  color: Colors.orange,
                  height: 50,
                  width: 50,
                  shadowSpreadRadius: 2,
                ),
              ],
            ),

            CircularButton(
              onTap: () {
                audio.directSound(audio.attenuationDistance, 0.0, 0.0);
                debugPrint('➡️ sound playing from right');
              },
              icon: Icons.keyboard_arrow_right_rounded,
              label: 'Right',
              shadowOffset: const Offset(-4, 0),
            ),
          ],
        ),

        const SizedBox(height: 60),

        CircularButton(
          onTap: () {
            audio.directSound(0.0, -audio.attenuationDistance, 0.0);
            debugPrint('⬇️ sound playing from bottom');
          },
          icon: Icons.keyboard_arrow_down_rounded,
          label: 'Bottom',
          shadowOffset: const Offset(0, -4),
        ),
      ],
    );
  }
}
