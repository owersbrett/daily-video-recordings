import 'package:habit_planet/data/habit.dart';
import 'package:habit_planet/pages/create_habit/typewriter_widget.dart';
import 'package:flutter/material.dart';
import 'package:habit_planet/service/admin_service.dart';
import '../../widgets/custom_progress_indicator.dart';
import '../../data/habit_entity.dart';
import '../../widgets/stylized_checkbox.dart';

class DisplayHabitCard extends StatefulWidget {
  const DisplayHabitCard(
      {super.key,
      required this.habitEntity,
      this.onCheck,
      this.onUncheck,
      this.progress = 100,
      this.checkable = true,
      required this.streakEmoji,
      required this.emoji});
  final HabitEntity habitEntity;
  final int progress;
  final bool checkable;
  final String streakEmoji;
  final String emoji;

  Habit get habit => habitEntity.habit;

  final VoidCallback? onCheck;
  final VoidCallback? onUncheck;
  @override
  State<DisplayHabitCard> createState() => _DisplayHabitCardState();
}

class _DisplayHabitCardState extends State<DisplayHabitCard> {
  String get habitString => habit.stringValue;
  Habit get habit => widget.habit;
  bool _completed = false;

  bool get checked {
    bool _checked = false;

    return _checked;
  }

  void _onCheck(bool? value) {
    setState(() {
      _completed = !_completed;
      if (_completed && widget.onCheck != null) {
        widget.onCheck!();
      } else if (!_completed && widget.onUncheck != null) {
        widget.onUncheck!();
      }
    });
  }

  double get gradientStop => _completed ? 1.0 : habit.value / 100.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black.withOpacity(1), width: 2),
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          child: _titleRow(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
                        child: widget.progress == 100
                            ? StylizedCheckbox(isChecked: true, color: HexColor.fromHex(habit.hexColor), onTap: () => _onCheck(_completed))
                            : CustomProgressIndicator(
                                size: ProgressIndicatorSize.medium,
                                value: widget.progress.toDouble(),
                                label: widget.progress.toStringAsPrecision(3) + "%",
                              ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 8,
                child: Text(widget.streakEmoji + "365", style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
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
    );
  }

  Column streak() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
          flex: 2,
          child: habitString.isEmpty
              ? TypewriterWidget(
                  textList: AdminService.get50Habits(0, true).map((e) => e.stringValue).toList(),
                  typingSpeed: Duration(milliseconds: 100),
                )
              : Text(
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
