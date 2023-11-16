import 'package:daily_video_reminders/bloc/experience/experience.dart';
import 'package:daily_video_reminders/bloc/habits/habits.dart';
import 'package:flutter/material.dart';

import 'custom_progress_indicator.dart';
import 'data/habit.dart';
import 'data/habit_entity.dart';
import 'data/habit_entry.dart';
import 'widgets/stylized_checkbox.dart';

class HabitEntryCard extends StatefulWidget {
  const HabitEntryCard({super.key, required this.habit, required this.habitEntry});
  final HabitEntry habitEntry;
  final Habit habit;

  @override
  State<HabitEntryCard> createState() => _HabitEntryCardState();
}

class _HabitEntryCardState extends State<HabitEntryCard> {
  String get habitString => habit.verb + " " + habit.valueGoal.toString() + " " + habit.suffix;
  Habit get habit => widget.habit;
  bool get _completed => widget.habitEntry.booleanValue;


  void _onCheck(bool? value) {
    BlocProvider.of<HabitsBloc>(context).add(UpdateHabitEntry(habit, widget.habitEntry.copyWith(booleanValue: !widget.habitEntry.booleanValue), BlocProvider.of<ExperienceBloc>(context)));
  }

  String get _starBuilder {
    String stars = "";
    if (habit.value < 1) {
      stars = "⭐";
    } else if (habit.value < 10) {
      stars = "⭐⭐";
    } else if (habit.value < 100) {
      stars = "⭐⭐⭐";
    }
    if (_completed) stars += "⭐";

    return stars;
    ;
  }

  double get gradientStop => _completed ? 1.0 : habit.value / 100.0;

  @override
  Widget build(BuildContext context) {
    return  Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: HexColor.fromHex(habit.hexColor).withOpacity(.5), width: 2),
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
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          child: _titleRow(),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
                          child: StylizedCheckbox(isChecked: _completed, color: HexColor.fromHex(habit.hexColor), onTap: () => _onCheck(_completed))),
                    ],
                  ),
                ],
              ),
              starAndStreakRow(),
              Positioned(
                  left: 8,
                  bottom: 8,
                  child: Text(
                    habit.frequencyType.toPrettyString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Column starAndStreakRow() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(_starBuilder),
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
        Text(habit.emoji, style: TextStyle(fontSize: 24)),
        SizedBox(width: 8),
        Text(
          habitString,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Expanded(child: Container()),
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