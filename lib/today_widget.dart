import 'package:daily_video_reminders/dropdown_chip.dart';
import 'package:daily_video_reminders/home_page.dart';
import 'package:daily_video_reminders/today_is_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TodayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String day = DateFormat('EEEE').format(DateTime.now());

    return Stack(
      children: [
        TodayIsWidget(),
        Row(
          children: [
            Expanded(
              child: DropdownChip<String>(
                items: ["All", "Good", "Bad"],
                onSelected: (String? value) {},
                selectedItem: "All",
                textColor: Colors.white,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: Container(),
            ),

            CupertinoIconButton(), // Top right corner
          ],
        ),
      ],
    );
  }
}
