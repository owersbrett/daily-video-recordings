import 'package:daily_video_reminders/data/habit_entity.dart';
import 'package:daily_video_reminders/data/habit_entry.dart';
import 'package:daily_video_reminders/habit_card.dart';
import 'package:daily_video_reminders/habit_entry_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/experience/experience.dart';
import '../../bloc/habits/habits.dart';
import '../../bloc/user/user.dart';
import '../../data/habit.dart';
import '../../widgets/weekday_hero.dart';

class WeekAndHabitsScrollView extends StatelessWidget {
  const WeekAndHabitsScrollView({super.key, required this.habitsState});
  DateTime get currentDay => habitsState.currentDate;
  final HabitsState habitsState;
  List<HabitEntry> get todaysHabitEntries => habitsState.todaysHabitEntries;
  Map<int, Habit> get habitsMap => habitsState.habitsMap;
  Map<int, List<HabitEntity>> get weekOfHabitEntities => habitsState.segregatedHabits();
  DateTime get now => DateTime.now();
  DateTime get yesterday => currentDay.subtract(const Duration(days: 1));
  DateTime get tomorrow => currentDay.add(const Duration(days: 1));

  DateTime get twoDaysAgo => yesterday.subtract(const Duration(days: 1));
  DateTime get twoDaysAhead => tomorrow.add(const Duration(days: 1));

  DateTime get threeDaysAgo => twoDaysAgo.subtract(const Duration(days: 1));
  DateTime get threeDaysAhead => twoDaysAhead.add(const Duration(days: 1));
  List<Widget> days(BuildContext context) => [
        wdh(threeDaysAgo, (habitsState.getRelativeHabitEntriesPercentage(-3) * 100).toInt(), context),
        wdh(twoDaysAgo, (habitsState.getRelativeHabitEntriesPercentage(-2) * 100).toInt(), context),
        wdh(yesterday, (habitsState.getRelativeHabitEntriesPercentage(-1) * 100).toInt(), context),
        wdh(currentDay, (habitsState.getRelativeHabitEntriesPercentage(0) * 100).toInt(), context),
        wdh(tomorrow, (habitsState.getRelativeHabitEntriesPercentage(1) * 100).toInt(), context),
        wdh(twoDaysAhead, (habitsState.getRelativeHabitEntriesPercentage(2) * 100).toInt(), context),
        wdh(threeDaysAhead, (habitsState.getRelativeHabitEntriesPercentage(3) * 100).toInt(), context)
      ];

  Widget wdh(DateTime weekdayDate, int score, BuildContext context) => GestureDetector(
        onTap: () {
          BlocProvider.of<HabitsBloc>(context).add(FetchHabits(BlocProvider.of<UserBloc>(context).state.user.id!, weekdayDate));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: WeekdayHero(
            date: weekdayDate,
            score: score,
            // expanded: weekdayDate == selectedDate,
            expanded: weekdayDate == currentDay,
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
  List<Widget> habitWidgets(BuildContext context) => todaysHabitEntries
      .map((e) => HabitEntryCard(
            habit: habitsMap[e.habitId] ?? Habit.empty(),
            habitEntry: e,
            currentListDate: currentDay,
          ))
      .toList();

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
