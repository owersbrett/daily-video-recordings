import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/habits/habits.dart';
import '../../bloc/user/user.dart';
import '../../data/repositories/habit_entry_repository.dart';
import '../../widgets/weekday_hero.dart';

class DateScrollingWidget extends StatelessWidget {
  const DateScrollingWidget({super.key, required this.currentDate});
  final DateTime currentDate;
  Widget wdh(DateTime weekdayDate, BuildContext context) {
    bool expanded = weekdayDate == currentDate;
    return Container(
      width: (MediaQuery.of(context).size.width / 8) * (expanded ? 2 : 1),
      child: Center(
        child: FutureBuilder(
            future: RepositoryProvider.of<IHabitEntryRepository>(context).getHabitEntryPercentagesForDay(weekdayDate),
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
                    expanded: expanded,
                    key: ValueKey(weekdayDate.day),
                  ),
                ),
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          BlocProvider.of<HabitsBloc>(context).add(FetchHabits(BlocProvider.of<UserBloc>(context).state.user.id!, currentDate.subtract(Duration(days: 7))));
        } else if (details.primaryVelocity! < 0) {
          BlocProvider.of<HabitsBloc>(context).add(FetchHabits(BlocProvider.of<UserBloc>(context).state.user.id!, currentDate.add(Duration(days: 7))));
        }
      },
      child: Container(
        color: Colors.white,
          height: kToolbarHeight * 2.2,
          child: Row(
            children: [
              wdh(currentDate.subtract(Duration(days: 3)), context),
              wdh(currentDate.subtract(Duration(days: 2)), context),
              wdh(currentDate.subtract(Duration(days: 1)), context),
              wdh(currentDate, context),
              wdh(currentDate.add(Duration(days: 1)), context),
              wdh(currentDate.add(Duration(days: 2)), context),
              wdh(currentDate.add(Duration(days: 3)), context)
            ],
          )),
    );
  }
}
