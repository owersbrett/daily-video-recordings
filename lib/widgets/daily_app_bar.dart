import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:habit_planet/bloc/habits/habits.dart';
import 'package:habit_planet/pages/home/custom_circular_indicator_v2.dart';
import 'package:habit_planet/pages/home/orbital_indicator.dart';
import 'package:habit_planet/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:habit_planet/widgets/today_is_widget.dart';
import 'package:sqflite/sqflite.dart';

import '../bloc/user/user.dart';
import '../navigation/navigation.dart';
import '../service/database_service.dart';
import '../tooltip_text.dart';
import '../util/date_util.dart';
import 'sql_editor.dart';

class DailyAppBar extends StatefulWidget {
  const DailyAppBar({super.key, required this.icon, required this.currentDate});
  final Widget icon;
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
                      color: Colors.black,
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
                                    BlocProvider.of<HabitsBloc>(ctx)
                                        .add(FetchHabits(BlocProvider.of<UserBloc>(context).state.user.id!, DateTime.now()));
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text(
                                    "TODAY",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

            // ----------------------------
            // TODO for testing
            // IconButton(
            //   onPressed: () {
            //     Navigation.createRoute(SQLEditor(db: RepositoryProvider.of<Database>(context)), context, AnimationEnum.fadeIn);
            //   },
            //   icon: const Icon(
            //     Icons.admin_panel_settings,
            //     color: Colors.black,
            //   ),
            // ),
            // ----------------------------

            Tooltip(
              message: TooltipText.welcome,
              child: FloatingActionButton.small(
                elevation: 3,
                heroTag: "Mood",
                enableFeedback: true,
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  BlocProvider.of<UserBloc>(context).add(SplashPageRequested());
                },
                child: Icon(Icons.mood_rounded),
              ),
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
