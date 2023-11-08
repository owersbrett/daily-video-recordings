import 'package:daily_video_reminders/data/habit.dart';
import 'package:daily_video_reminders/stylized_checkbox.dart';
import 'package:flutter/material.dart';

class HabitCard extends StatefulWidget {
  const HabitCard({super.key, required this.habit});
  final Habit habit;

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  Habit get habit => widget.habit;
  bool _completed = false;
  void _onCheck(bool? value) {
    setState(() {
      _completed = !_completed;
    });
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              HexColor.fromHex(habit.hexColor).withOpacity(.3),
              HexColor.fromHex(habit.hexColor).withOpacity(.1),
            ],
            stops: [_completed ? .5 : 0.5, gradientStop],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0, top: 4, bottom: 4),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(),
                                ),
                                Text("")
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: _titleRow(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Text(habit.metricThree),
                    ),
                    Expanded(
                      child: Container(),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 16,  bottom: 16),
                      child: StylizedCheckbox(
                          isChecked: _completed,
                          onTap: () => _onCheck(_completed)),
                    ),
                  ],
                ),
              ],
            ),
            starAndStreakRow(),
          ],
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(habit.metricTwo),
            ),
          ],
        ),
      ],
    );
  }

  Row _titleRow() {
    return Row(
      children: [
        Text(
          habit.emoji,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          habit.title,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Expanded(
          child: Container(),
        ),
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
