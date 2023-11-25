import 'package:flutter/cupertino.dart';
import 'package:mementoh/bloc/habits/habits.dart';
import 'package:mementoh/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mementoh/widgets/today_is_widget.dart';

import '../bloc/user/user.dart';
import '../util/date_util.dart';

class DailyAppBar extends StatefulWidget {
  const DailyAppBar({super.key, required this.icon, required this.currentDate});
  final IconButton icon;
  final DateTime currentDate;

  @override
  State<DailyAppBar> createState() => _DailyAppBarState();
}

class _DailyAppBarState extends State<DailyAppBar> {
  DateTime? currentDay;

  @override
  void initState() {
    super.initState();
    currentDay = BlocProvider.of<HabitsBloc>(context).state.currentDate;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: TextButton(
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (ctx) {
                    return Container(
                      height: 400,
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 300,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: currentDay,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() {
                                  currentDay = newDate.add(Duration(hours: 1));
                                });
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 100,
                                child: CupertinoButton(
                                
                                  onPressed: () {
                                    if (currentDay == null) {
                                      return;
                                    }
                                    BlocProvider.of<HabitsBloc>(ctx).add(FetchHabits(BlocProvider.of<UserBloc>(context).state.user.id!, DateTime.now()));
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text(
                                    "TODAY",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                height: 100,
                                child: CupertinoButton(
                                  onPressed: () {
                                    if (currentDay == null) {
                                      return;
                                    }
                                    BlocProvider.of<HabitsBloc>(ctx).add(FetchHabits(BlocProvider.of<UserBloc>(context).state.user.id!, currentDay!));
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text(
                                    "SELECT",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  });
              // BlocProvider.of<HabitsBloc>(context).add(FetchHabits(BlocProvider.of<UserBloc>(context).state.user.id!, DateTime.now()));
            },
            child: DateUtil.isSameDay(DateTime.now(), widget.currentDate)
                ? const TodayIsWidget()
                : Text(getDayString(), style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
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
            widget.icon
          ],
        ),
      ],
    );
  }

  String getDayString() {
    if (DateUtil.isSameDay(widget.currentDate, DateTime.now())) {
      return "Today";
    } else if (DateUtil.isSameDay(widget.currentDate, DateTime.now().subtract(const Duration(days: 1)))) {
      return "Yesterday";
    } else if (DateUtil.isSameDay(widget.currentDate, DateTime.now().add(const Duration(days: 1)))) {
      return "Tomorrow";
    } else {
      return DateFormat("MMMM dd, yyyy").format(widget.currentDate);
    }
  }
}
