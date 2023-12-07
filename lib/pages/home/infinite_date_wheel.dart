import 'package:flutter/material.dart';

import '../../bloc/habits/habits.dart';
import '../../bloc/user/user.dart';
import '../../data/repositories/habit_entry_repository.dart';
import '../../widgets/weekday_hero.dart';

class InfiniteDateWheel extends StatefulWidget {
  @override
  _InfiniteDateWheelState createState() => _InfiniteDateWheelState();
}

class _InfiniteDateWheelState extends State<InfiniteDateWheel> {
  final ScrollController _scrollController = ScrollController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Scroll to today's date initially
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToSelectedDate());
  }

  void scrollToSelectedDate() {
    final int daysSinceStart = selectedDate.difference(DateTime.now()).inDays;
    final double offset = daysSinceStart * kToolbarHeight * 2.5;
    _scrollController.jumpTo(offset);
  }

  Widget wdh(DateTime date, BuildContext context, DateTime currentDate) {
    // Your widget for displaying the date here
    return FutureBuilder(
        future: RepositoryProvider.of<IHabitEntryRepository>(context).getHabitEntryPercentagesForWeekSurroundingDate(date),
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: () {
              BlocProvider.of<HabitsBloc>(context).add(FetchHabits(BlocProvider.of<UserBloc>(context).state.user.id!, date));
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: WeekdayHero(
                date: date,
                score: snapshot.hasData ? ((snapshot.data ?? 0) * 100).toInt() : 0,
                // expanded: weekdayDate == selectedDate,
                expanded: date == currentDate,
                key: ValueKey(date.day),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HabitsBloc, HabitsState>(
      listener: (context, state) {
        setState(() {
          selectedDate = state.currentDate;
        });
        scrollToSelectedDate();
      },
      listenWhen: (previous, current) {
        return previous.currentDate != current.currentDate;
      },
      child: Container(
        height: kToolbarHeight * 2.5,
        child: BlocBuilder<HabitsBloc, HabitsState>(
          builder: (context, state) {
            var currentDate = state.currentDate;
            return ListView.builder(
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                // Calculate the date for each item
                final date = DateTime.now().subtract(Duration(days: 3 - index));
                return Container(
                  height: kToolbarHeight * 2.5,
                  child: wdh(date, context, currentDate),
                );
              },
              scrollDirection: Axis.horizontal,
              // Set itemCount to null for infinite scrolling
              itemCount: null,
            );
          },
        ),
      ),
    );
  }
}
