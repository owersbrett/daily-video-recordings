// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:daily_video_reminders/main.dart';
import 'package:daily_video_reminders/pages/home/now_data.dart';
import 'package:daily_video_reminders/widgets/custom_circular_indicator.dart';
import 'package:daily_video_reminders/widgets/weekday_hero.dart';

import '../../bloc/experience/experience.dart';

class Mementoh extends StatefulWidget {
  const Mementoh({
    Key? key,
    required this.onStart,
    required this.nowData,
  }) : super(key: key);
  final Function onStart;
  final NowData nowData;

  @override
  State<Mementoh> createState() => _MementohState();
}

class _MementohState extends State<Mementoh> {
  DateTime get currentTime => DateTime.now();
  Duration countdownDuration = Duration(hours: 1);
  Duration get remainingTime => countdownDuration - currentTime.difference(widget.nowData.startTimerTimer ?? DateTime.now());
  double get remainingDurationExpressedAsDouble => remainingTime.inSeconds / countdownDuration.inSeconds;
  void _updateDuration(DragUpdateDetails details) {
    // Calculate the change in duration based on the drag distance
    const sensitivityFactor = 5; // Adjust this for more/less sensitivity
    int seconds = (details.primaryDelta ?? 0 * sensitivityFactor).round();

    setState(() {
      int newSeconds = countdownDuration.inSeconds + seconds;
      countdownDuration = Duration(seconds: max(0, newSeconds)); // Ensure non-negative duration
    });
  }

  double getremainingDurationPercentage(Duration originalDuration, Duration remainingDuration) {
    if (originalDuration.inSeconds == 0) {
      return 0; // Avoid division by zero
    }
    double percentage = (remainingDuration.inSeconds / originalDuration.inSeconds) * 100;
    return percentage.clamp(0, 100); // Ensures the value is between 0 and 100
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExperienceBloc, ExperienceState>(
      builder: (context, state) {
        var level = state.currentLevel();
        var percentageToNextLevel = state.percentageToNextLevel();
        return Container(
          padding: EdgeInsets.all(10), // Add padding if needed
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // To center the column content vertically
              crossAxisAlignment: CrossAxisAlignment.center, // To center the column content horizontally
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Mementoh',
                  style: TextStyle(
                      fontSize: 24, // Adjust the font size as needed
                      fontWeight: FontWeight.bold, // Make the title bold
                      color: Colors.white),
                ),
                Text(
                  'Habit Tracker',
                  style: TextStyle(
                    fontSize: 16, // Adjust the font size as needed
                    color: Colors.grey[600], // Adjust the color as needed
                  ),
                  textAlign: TextAlign.center, // Center align the subtitle text
                ),
                SizedBox(height: 32), // Space between subtitle and button
                Text(
                  widget.nowData.getWeekAndSeason(widget.nowData.currentTime),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32), // Space between subtitle and button
                CustomCircularIndicator(
                  expanded: true,
                  score: (percentageToNextLevel * 100).toInt(),
                  key: ValueKey("weekday-hero"),
                  textColor: Colors.white,
                  centerValue: level.toString(),
                  title: "Level",
                ),
                SizedBox(height: 36), // Space between subtitle and button
                Text(
                  "Welcome to Mementoh",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12), // Space between subtitle and button
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(
                  children: [
                    Text(
                      "Features:",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                    SizedBox(height: 12), // Space between subtitle and button
                    Text("- Add Habits To Track Consistency", style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(height: 12), // Space between subtitle and button
                    Text("- Add Videos To Leave Mementos", style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(height: 12), // Space between subtitle and button
                    Text("- Gain Experience To Level Up", style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(height: 12), // Space between subtitle and button
                    Text("- Visualize The Passage of Time", style: TextStyle(color: Colors.white, fontSize: 12)),

                  ],
                ),
                // GestureDetector(
                //   onHorizontalDragUpdate: _updateDuration,
                //   child: TextButton(
                //     onPressed: () => widget.onStart(),
                //     child: Text(
                //       widget.nowData.formatDuration(remainingTime),
                //       style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
