import 'package:daily_video_reminders/dropdown_chip.dart';
import 'package:daily_video_reminders/pages/home/home_page.dart';
import 'package:daily_video_reminders/theme/theme.dart';
import 'package:daily_video_reminders/widgets/nav_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyAppBar extends StatelessWidget {
  const DailyAppBar({super.key, required this.icon});
  final IconButton icon;

  @override
  Widget build(BuildContext context) {
    String day = DateFormat('EEEE').format(DateTime.now());

    return Container(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 24, color: Colors.black), // Default text style
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Today ',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextSpan(
                        text: 'is $day',
                        style: TextStyle(
                            fontSize:
                                14)), // No specific style applied, so it uses default
                  ],
                ),
              ),
            ),
          ),
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
              icon
            ],
          ),
        ],
      ),
    );
  }
}
