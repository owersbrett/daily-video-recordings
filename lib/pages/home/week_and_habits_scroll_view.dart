import 'package:mementoh/data/habit_entity.dart';
import 'package:mementoh/data/habit_entry.dart';
import 'package:mementoh/habit_card.dart';
import 'package:mementoh/habit_entry_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mementoh/pages/create_habit/create_a_habit.dart';
import 'package:mementoh/pages/create_habit/display_habit_card.dart';
import 'package:mementoh/pages/create_habit/update_a_habit.dart';

import '../../bloc/experience/experience.dart';
import '../../bloc/habits/habits.dart';
import '../../bloc/user/user.dart';
import '../../data/habit.dart';
import '../../navigation/navigation.dart';
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
  List<Widget> habitWidgets(BuildContext context) {
    if (todaysHabitEntries.isEmpty) {
      return [
        const SizedBox(height: kToolbarHeight),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24),
          child: Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                Navigation.createRoute(CreateHabitPage(dateToAddHabit: habitsState.currentDate), context);
              },
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "No habit entries.\nTap to create one!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: kToolbarHeight),
      ];
    }
    return todaysHabitEntries
        .map((e) => GestureDetector(
              onTap: () {
                if (habitsState.getHabit(e.habitId) != null) {
                  Navigation.createRoute(UpdateHabitPage(dateToAddHabit: habitsState.currentDate, habit: habitsState.getHabit(e.habitId)!), context);
                }
              },
              child: HabitEntryCard(
                habit: habitsMap[e.habitId] ?? Habit.empty(),
                habitEntry: e,
                currentListDate: currentDay,
              ),
            ))
        .toList();
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
