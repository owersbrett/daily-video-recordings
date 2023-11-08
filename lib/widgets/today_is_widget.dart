import 'package:daily_video_reminders/dropdown_chip.dart';
import 'package:daily_video_reminders/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TodayIsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String day = DateFormat('EEEE').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: 24, color: Colors.black), // Default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'Today ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextSpan(
                  text: 'is $day',
                  style: TextStyle(
                      fontSize:
                          14)), // No specific style applied, so it uses default
            ],
          ),
        ),
      ),
    );
  }
}
