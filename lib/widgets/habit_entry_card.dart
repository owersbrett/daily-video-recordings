import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:is_audio_playing/is_audio_playing.dart';
import 'package:mementohr/bloc/experience/experience.dart';
import 'package:mementohr/bloc/habits/habits.dart';
import 'package:flutter/material.dart';
import 'package:mementohr/data/repositories/habit_entry_repository.dart';

import '../data/habit.dart';
import '../data/habit_entity.dart';
import '../data/habit_entry.dart';
import '../main.dart';
import '../util/date_util.dart';
import 'stylized_checkbox.dart';
import 'package:flutter_sound/flutter_sound.dart';

class HabitEntryCard extends StatefulWidget {
  const HabitEntryCard({super.key, required this.habit, required this.habitEntry, required this.currentListDate});
  final HabitEntry habitEntry;
  final Habit habit;
  final DateTime currentListDate;
  @override
  State<HabitEntryCard> createState() => _HabitEntryCardState();
}

class _HabitEntryCardState extends State<HabitEntryCard> {
  String get habitString => habit.stringValue;
  AudioPlayer audioPlayer = AudioPlayer();
  IsAudioPlaying isAudioPlaying = IsAudioPlaying();

  Habit get habit => widget.habit;
  bool buttonsExpanded = false;
  bool noteExpanded = false;
  bool get _completed => widget.habitEntry.booleanValue;

  void _onCheck(bool? value) async {
    HapticFeedback.mediumImpact();
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    if (widget.currentListDate.isAfter(endOfDay)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You're a liar, that's in the future."),
        backgroundColor: Colors.black,
      ));
    }
    //  else if (widget.currentListDate.isBefore(startOfDay)) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text("You can't change the past."),
    //     backgroundColor: Colors.black,
    //   ));
    // }
    else {
      if (!widget.habitEntry.booleanValue) {
        audioPlayer.setPlayerMode(PlayerMode.lowLatency);
        audioPlayer.setVolume(0.2);
        if (!(await isAudioPlaying.isAudioPlaying() ?? true)) {
          audioPlayer.play(AssetSource("audio/shimmer.wav"), volume: .02);
        }
      }
      BlocProvider.of<HabitsBloc>(context).add(UpdateHabitEntry(habit, widget.habitEntry.copyWith(booleanValue: !widget.habitEntry.booleanValue),
          BlocProvider.of<ExperienceBloc>(context), widget.currentListDate));
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  double get gradientStop => _completed ? 1.0 : habit.value / 100.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   setState(() {
      //     buttonsExpanded = !buttonsExpanded;
      //   });
      // },
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black.withOpacity(.5), width: 2),
                  gradient: LinearGradient(
                    colors: [
                      HexColor.fromHex(habit.hexColor).withOpacity(.5),
                      HexColor.fromHex(habit.hexColor).withOpacity(.3),
                    ],
                    stops: [_completed ? .5 : 0.5, gradientStop],
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  _titleRow(),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
                              child: StylizedCheckbox(
                                key: Key(habit.stringValue),
                                isChecked: _completed,
                                color: HexColor.fromHex(habit.hexColor),
                                onTap: () => _onCheck(_completed),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    BlocBuilder<HabitsBloc, HabitsState>(
                      builder: (context, state) {
                        return streakRow(state.habitMap[habit.id]);
                      },
                    ),
                    Positioned(
                        left: 8,
                        bottom: 8,
                        child: Text(
                          habit.frequencyType.toUiString(),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column streakRow(HabitEntity? habitEntity) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(habit.streakEmoji, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: FutureBuilder(
                future: RepositoryProvider.of<IHabitEntryRepository>(context).getStreakFromHabitAndDate(habit, widget.currentListDate),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(((snapshot.data ?? 0)).toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
                  } else {
                    return Text(_completed ? "1" : "0", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
                  }
                },
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ],
    );
  }

  Row _titleRow() {
    return Row(
      children: [
        Text(habit.emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            habitString,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
