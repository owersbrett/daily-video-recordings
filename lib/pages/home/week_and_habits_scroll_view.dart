import 'package:daily_video_reminders/data/habit_entity.dart';
import 'package:daily_video_reminders/data/habit_entry.dart';
import 'package:daily_video_reminders/habit_card.dart';
import 'package:daily_video_reminders/habit_entry_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/experience/experience.dart';
import '../../bloc/habits/habits.dart';
import '../../data/habit.dart';
import '../../widgets/weekday_hero.dart';

class WeekAndHabitsScrollView extends StatelessWidget {
  const WeekAndHabitsScrollView(
      {super.key, required this.todaysHabitEntries, required this.currentDay, required this.weekOfHabitEntities, required this.habitsMap});
  final DateTime currentDay;
  final List<HabitEntry> todaysHabitEntries;
  final Map<int, Habit> habitsMap;
  final Map<int, List<HabitEntity>> weekOfHabitEntities;
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

  void uncheckHabit(HabitEntity e, BuildContext context) {
    var habitEntry = e.habitEntries.firstWhere((element) => element.habitId == e.habit.id);
    habitEntry = habitEntry.copyWith(booleanValue: !habitEntry.booleanValue);
    BlocProvider.of<HabitsBloc>(context).add(UpdateHabitEntry(e.habit, habitEntry, BlocProvider.of<ExperienceBloc>(context)));
  }

  void checkHabit(HabitEntity e, BuildContext context) {
    var habitEntry = e.habitEntries.firstWhere((element) => element.habitId == e.habit.id);
    habitEntry = habitEntry.copyWith(booleanValue: !habitEntry.booleanValue);
    BlocProvider.of<HabitsBloc>(context).add(UpdateHabitEntry(e.habit, habitEntry, BlocProvider.of<ExperienceBloc>(context)));
  }

  List<Widget> dayWidgets(BuildContext context) => days(context);
  List<Widget> habitWidgets(BuildContext context) {
    List<Widget> widgets = [];
    widgets = todaysHabitEntries.map((e) => HabitEntryCard (habit: habitsMap[e.habitId] ?? Habit.empty(), habitEntry: e)).toList();
    // widgets = weekOfHabitEntities[0]?.map((entity) => entity.habitEntries.map((entry) => HabitEntryCard(habitEntry: entry, habit: entity.habit))).toList() ?? [];
    return widgets;
    // widgets = weekOfHabitEntities[0]?.map((e) => HabitCard(habitEntity: e, onUncheck: () {
    //       uncheckHabit(e, context);
    // }, onCheck: () => checkHabit(e, context), habitEntry: null,)).toList() ?? [];
    // return widgets;
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
          child: ListView(
            children: [...habitWidgets(context), const SizedBox(height: kToolbarHeight)],
          ),
        ),
      ],
    ));
  }
}

class HabitEntryEntity {
  HabitEntryEntity({required this.habitEntry, required this.habit});
  HabitEntry habitEntry;
  Habit habit;
}
