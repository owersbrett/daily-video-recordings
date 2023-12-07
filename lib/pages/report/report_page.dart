import 'package:habit_planet/bloc/reports/reports.dart';
import 'package:habit_planet/pages/home/annual_report.dart';
import 'package:habit_planet/pages/home/calendar_grid.dart';
import 'package:habit_planet/widgets/weekly_report_grid.dart';
import 'package:flutter/material.dart';
import '../../bloc/habits/habits.dart';
import '../../bloc/user/user.dart';
import '../../data/habit_entry.dart';
import '../../util/date_util.dart';
import '../home/backswipe.dart';
import '../video/dvr_close_button.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReportsBloc>(context).add(FetchReports(
        BlocProvider.of<UserBloc>(context).state.user.id!, DateUtil.closestPastMonday(DateTime.now()), DateUtil.closestComingSunday(DateTime.now())));
    tabController = TabController(length: tabs().length, vsync: this);
  }

  List<Widget> tabs() => [
        BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            Map<int, List<HabitEntry>> weekOfHabitEntries = {};

            if (state is ReportsLoaded) {
              weekOfHabitEntries = state.weekOfHabitEntries;
            }
            return Column(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: WeeklyReportGrid(
                      habits: state.habits,
                      startInterval: state.startInterval,
                      endInterval: state.endInterval,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        BlocBuilder<HabitsBloc, HabitsState>(builder: (context, state) {
          return CalendarGrid(
            startDate: DateTime.now(),
            habits: state.habitsMap.values.toList(),
          );
        }),
        // CenteredGridScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs().length,
      child: Scaffold(
          body: Column(
        children: [
          Container(
            height: kToolbarHeight,
          ),
          Row(
            children: [
              DVRCloseButton(
                onPressed: () => Navigator.of(context).pop(),
                positioned: false,
                color: Colors.black,
              ),
              Expanded(
                child: TabBar(
                  controller: tabController,
                  tabs: [
                    Tab(text: "Weekly"),
                    Tab(text: "Monthly"),
                    // Tab(text: "Yearly"),
                  ],
                ),
              ),
              DVRCloseButton(
                onPressed: () => Navigator.of(context).pop(),
                positioned: false,
                color: Colors.black,
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: tabs(),
            ),
          ),
        ],
      )),
    );
  }
}
