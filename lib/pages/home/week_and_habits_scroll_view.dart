import 'package:mementohr/data/habit_entity.dart';
import 'package:mementohr/data/habit_entry.dart';
import 'package:mementohr/data/repositories/habit_entry_repository.dart';
import 'package:mementohr/pages/home/custom_circular_indicator_v2.dart';
import 'package:mementohr/pages/video/loading_page.dart';
import 'package:mementohr/widgets/habit_entry_card.dart';
import 'package:flutter/material.dart';
import 'package:mementohr/pages/create_habit/create_a_habit.dart';
import 'package:mementohr/pages/create_habit/update_a_habit.dart';

import '../../bloc/experience/experience.dart';
import '../../bloc/habits/habits.dart';
import '../../bloc/user/user.dart';
import '../../data/habit.dart';
import '../../navigation/navigation.dart';
import '../../util/date_util.dart';
import '../../widgets/weekday_hero.dart';

class WeekAndHabitsScrollView extends StatelessWidget {
  const WeekAndHabitsScrollView({super.key, required this.habitsState});
  DateTime get currentDay => DateUtil.startOfDay(habitsState.currentDate);
  final HabitsState habitsState;
  // List<HabitEntry> get todaysHabitEntries => habitsState.todaysHabitEntries;
  Map<int, Habit> get habitsMap => habitsState.habitsMap;
  Map<int, List<HabitEntity>> get weekOfHabitEntities => habitsState.segregatedHabits();
  DateTime get now => DateUtil.startOfDay(DateTime.now());
  DateTime get yesterday => currentDay.copyWith(day: currentDay.day - 1);
  DateTime get tomorrow => currentDay.copyWith(day: currentDay.day + 1);

  DateTime get twoDaysAgo => yesterday.copyWith(day: yesterday.day - 1);
  DateTime get twoDaysAhead => tomorrow.copyWith(day: tomorrow.day + 1);

  DateTime get threeDaysAgo => twoDaysAgo.copyWith(day: twoDaysAgo.day - 1);
  DateTime get threeDaysAhead => twoDaysAhead.copyWith(day: twoDaysAhead.day + 1);

  Widget wdh(DateTime weekdayDate, BuildContext context) => FutureBuilder(
      future: RepositoryProvider.of<IHabitEntryRepository>(context).getHabitEntryPercentagesForWeekSurroundingDate(weekdayDate),
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            BlocProvider.of<HabitsBloc>(context).add(FetchHabits(BlocProvider.of<UserBloc>(context).state.user.id!, weekdayDate));
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: WeekdayHero(
              date: weekdayDate,
              score: snapshot.hasData ? ((snapshot.data ?? 0) * 100).toInt() : 0,
              // expanded: weekdayDate == selectedDate,
              expanded: weekdayDate == currentDay,
              key: ValueKey(weekdayDate.day),
            ),
          ),
        );
      });

  void uncheckHabit(HabitEntity e, BuildContext context) {
    var habitEntry = e.habitEntries.firstWhere((element) => element.habitId == e.habit.id);
    habitEntry = habitEntry.copyWith(booleanValue: !habitEntry.booleanValue);
    BlocProvider.of<HabitsBloc>(context).add(UpdateHabitEntry(e.habit, habitEntry, BlocProvider.of<ExperienceBloc>(context), currentDay));
  }

  void checkHabit(HabitEntity e, BuildContext context) {
    var habitEntry = e.habitEntries.firstWhere((element) => element.habitId == e.habit.id);
    habitEntry = habitEntry.copyWith(booleanValue: !habitEntry.booleanValue);
    BlocProvider.of<HabitsBloc>(context).add(UpdateHabitEntry(e.habit, habitEntry, BlocProvider.of<ExperienceBloc>(context), currentDay));
  }

  List<Widget> habitWidgets(BuildContext context, List<HabitEntry> todaysHabitEntries) {
    if (todaysHabitEntries.isEmpty) {
      if (habitsState is! HabitsLoaded) {
        return [const CircularProgressIndicator()];
      }
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
              child: const Padding(
                padding: EdgeInsets.all(24.0),
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
              key: Key("${e.habitId}:${e.id}"),
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
        children: [
          Row(
            children: [
              wdh(threeDaysAgo, context),
              wdh(twoDaysAgo, context),
              wdh(yesterday, context),
              wdh(currentDay, context),
              wdh(tomorrow, context),
              wdh(twoDaysAhead, context),
              wdh(threeDaysAhead, context)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Expanded(
          child: FutureBuilder(
              future: RepositoryProvider.of<IHabitEntryRepository>(context).getByDate(habitsState.currentDate),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const LoadingPage();
                }
                return ListView(
                  children: [...habitWidgets(context, snapshot.data ?? []), const SizedBox(height: kToolbarHeight * 1.5)],
                );
              },
          ),
        ),
        ],
      ),
    );
  }
}
