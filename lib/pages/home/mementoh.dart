import 'package:daily_video_reminders/main.dart';
import 'package:daily_video_reminders/pages/home/now_data.dart';
import 'package:daily_video_reminders/widgets/weekday_hero.dart';
import 'package:flutter/material.dart';

class Mementoh extends StatefulWidget {
  const Mementoh({Key? key, required this.nowData, required this.onStart}) : super(key: key);
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

  double getremainingDurationPercentage(Duration originalDuration, Duration remainingDuration) {
    if (originalDuration.inSeconds == 0) {
      return 0; // Avoid division by zero
    }
    double percentage = (remainingDuration.inSeconds / originalDuration.inSeconds) * 100;
    return percentage.clamp(0, 100); // Ensures the value is between 0 and 100
  }

  @override
  Widget build(BuildContext context) {
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
            WeekdayHero(
              date: DateTime.now(),
              expanded: true,
              score: getremainingDurationPercentage(countdownDuration, remainingTime).toInt(),
              key: ValueKey("weekday-hero"),
              textColor: Colors.white,
            ),
            SizedBox(height: 36), // Space between subtitle and button
            GestureDetector(
              onHorizontalDragUpdate: (details) {},
              child: TextButton(
                  onPressed:()=> widget.onStart(),
                  child: Text(
                    widget.nowData.formatDuration(remainingTime),
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
