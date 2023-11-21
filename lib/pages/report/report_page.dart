import 'package:mementoh/bloc/reports/reports.dart';
import 'package:mementoh/widgets/habit_grid.dart';
import 'package:flutter/material.dart';
import '../../bloc/habits/habits.dart';
import '../../bloc/user/user.dart';
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
        .add(FetchReports(BlocProvider.of<UserBloc>(context).state.user.id!, DateUtil.closestPastMonday(), DateUtil.closestComingSunday()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: HabitGrid(
                  habits: state.habits,
                  habitEntries: state.currentHabitEntries,
                  startInterval: state.startInterval,
                  endInterval: state.endInterval,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
