import 'package:mementoh/bloc/habits/habits.dart';
import 'package:mementoh/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../bloc/user/user.dart';

class DailyAppBar extends StatelessWidget {
  const DailyAppBar({super.key, required this.icon});
  final IconButton icon;

  @override
  Widget build(BuildContext context) {
    String day = DateFormat('EEEE').format(DateTime.now());

    return Stack(
      children: [
        TextButton(
          onPressed: () {
            BlocProvider.of<HabitsBloc>(context).add(FetchHabits(BlocProvider.of<UserBloc>(context).state.user.id!, DateTime.now()));
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 24, color: Colors.black), // Default text style
                  children: <TextSpan>[
                    const TextSpan(text: 'Today ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextSpan(text: 'is $day', style: const TextStyle(fontSize: 14)), // No specific style applied, so it uses default
                  ],
                ),
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
                          .map(
                            (e) => TextButton(
                              onPressed: () => AdminService.handleAdminCommand(context, e).then((value) => Navigator.of(ctx).pop()),
                              child: Text(
                                e,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.admin_panel_settings),
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
    );
  }
}
