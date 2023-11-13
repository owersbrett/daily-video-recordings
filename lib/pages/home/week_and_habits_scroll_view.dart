import 'package:daily_video_reminders/data/habit_entity.dart';
import 'package:daily_video_reminders/data/habit_entry.dart';
import 'package:daily_video_reminders/habit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/weekday_hero.dart';

class WeekAndHabitsScrollView extends StatelessWidget {
  const WeekAndHabitsScrollView({super.key, required this.currentDay, required this.weekOfHabitEntities, required this.todaysHabitEntities});
  final DateTime currentDay;
  final List<List<HabitEntity>> weekOfHabitEntities;
  final List<HabitEntity> todaysHabitEntities;
  DateTime get now => DateTime.now();
  DateTime get yesterday => currentDay.subtract(const Duration(days: 1));
  DateTime get tomorrow => currentDay.add(const Duration(days: 1));

  DateTime get twoDaysAgo => yesterday.subtract(const Duration(days: 1));
  DateTime get twoDaysAhead => tomorrow.add(const Duration(days: 1));

  DateTime get threeDaysAgo => twoDaysAgo.subtract(const Duration(days: 1));
  DateTime get threeDaysAhead => twoDaysAhead.add(const Duration(days: 1));
  List<Widget> days(BuildContext context) => [
        wdh(threeDaysAgo, 12, context),
        wdh(twoDaysAgo, 40, context),
        wdh(yesterday, 50, context),
        wdh(currentDay, 100, context),
        wdh(tomorrow, 80, context),
        wdh(twoDaysAhead, 100, context),
        wdh(threeDaysAhead, 54, context)
      ];

  Widget wdh(DateTime weekdayDate, int score, BuildContext context) => GestureDetector(
        onTap: () {
          //  BlocProvider.of<HomePageBloc>(context).add(HomePageEvent.selectDay(weekdayDate));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: WeekdayHero(
            date: weekdayDate,
            score: score,
            // expanded: weekdayDate == selectedDate,
            expanded: false,
            key: ValueKey(weekdayDate.day),
          ),
        ),
      );
  List<Widget> dayWidgets(BuildContext context) => days(context);
  List<Widget> get habitWidgets {
    List<Widget> widgets = [];
    widgets = todaysHabitEntities.map((e) => HabitCard(habitEntity: e)).toList();
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: dayWidgets(context),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        Expanded(
          child: ListView(children: [...habitWidgets, SizedBox(height: kToolbarHeight,)],),
        ),
      ],
    ));
  }
}
