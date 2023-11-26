import 'package:mementohr/bloc/reports/reports.dart';
import 'package:mementohr/widgets/habit_grid.dart';
import 'package:flutter/material.dart';
import '../../bloc/habits/habits.dart';
import '../../bloc/user/user.dart';
import '../../data/habit_entry.dart';
import '../../util/date_util.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReportsBloc>(context)
        .add(FetchReports(BlocProvider.of<UserBloc>(context).state.user.id!, DateUtil.closestPastMonday(DateTime.now()), DateUtil.closestComingSunday(DateTime.now())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
  Map<int, List<HabitEntry>>  weekOfHabitEntries = {};

          if (state is ReportsLoaded) {
            weekOfHabitEntries = state.weekOfHabitEntries;
          }
          return Column(
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: HabitGrid(
                    habits: state.habits,
                    habitEntries: weekOfHabitEntries,
                    startInterval: state.startInterval,
                    endInterval: state.endInterval,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
