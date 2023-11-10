import 'package:daily_video_reminders/dropdown_chip.dart';
import 'package:daily_video_reminders/pages/home/home_page.dart';
import 'package:daily_video_reminders/theme/theme.dart';
import 'package:daily_video_reminders/widgets/nav_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'today_is_widget.dart';

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
                backgroundColor: emeraldLight,
                borderColor: emeraldLight,
                textColor: Colors.white,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: Container(),
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return Positioned(
                          child: Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Me"),
                                Text("You"),
                              ],
                            ),
                          ),
                          top: 0,
                          right: 0,
                        );
                      });
                },
                icon: Icon(CupertinoIcons.add))
          ],
        ),
      ],
    );
  }
}
