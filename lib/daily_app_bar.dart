import 'package:daily_video_reminders/dropdown_chip.dart';
import 'package:daily_video_reminders/pages/home/home_page.dart';
import 'package:daily_video_reminders/service/admin_service.dart';
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
                  style: TextStyle(fontSize: 24, color: Colors.black), // Default text style
                  children: <TextSpan>[
                    TextSpan(text: 'Today ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextSpan(text: 'is $day', style: TextStyle(fontSize: 14)), // No specific style applied, so it uses default
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              // Expanded(
              //   child: DropdownChip<String>(
              //     items: ["Admin", "-d -a Experience", "-d -a Entries", "-d -a Habits"],
              //     onSelected: (String? value) {
              //       AdminService.handleAdminCommand(context, value!);
              //     },
              //     selectedItem: "Admin",
              //     backgroundColor: Colors.black,
              //     borderColor: Colors.black,
              //     textColor: Colors.white,
              //   ),
              // ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                            title: const Text(
                              "Admin Service",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: AdminService.adminCommands
                                    .map((e) => TextButton(
                                        onPressed: () => AdminService.handleAdminCommand(context, e).then((value) => Navigator.of(ctx).pop()),
                                        child: Text(e, style: TextStyle(color: Colors.black))))
                                    .toList())));
                  },
                  icon: Icon(Icons.admin_panel_settings)),
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
