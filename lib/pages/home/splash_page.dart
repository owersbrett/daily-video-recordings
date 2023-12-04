import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitbit/bloc/user/user_event.dart';
import 'package:habitbit/service/admin_service.dart';
import 'package:habitbit/theme/theme.dart';

import '../../bloc/habits/habits.dart';
import '../../bloc/user/user_bloc.dart';
import '../../data/habit.dart';
import '../../data/user.dart';
import '../../tooltip_text.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({required this.user, super.key});
  final User user;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  List<Habit> habitsToAdd = [];
  List<Habit> habitsShown = [];

  @override
  initState() {
    super.initState();
    habitsShown = AdminService.get50Habits(widget.user.id!, true);
  }

  List<Widget> items() => habitsShown
      .map(
        (e) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  if (habitsToAdd.contains(e)) {
                    habitsToAdd.remove(e);
                  } else {
                    habitsToAdd.insert(0, e);
                  }
                });
              },
              child: chip(e)),
        ),
      )
      .toList();

  Widget chip(Habit habit) {
    return Tooltip(
      message: TooltipText.getHabitCardTooltip(habit.stringValue),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(8),
        color: habitsToAdd.contains(habit) ? Colors.black : Colors.white,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              habit.stringValue,
              style: TextStyle(color: habitsToAdd.contains(habit) ? Colors.white : Colors.black, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }

  void close() {
    BlocProvider.of<UserBloc>(context).add(SplashPageClosed());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Tooltip(
                  message: TooltipText.clickClose,
                  child: FloatingActionButton(
                    heroTag: "Close",
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      BlocProvider.of<UserBloc>(context).add(SplashPageClosed());
                    },
                    child: Icon(
                      Icons.close,
                      color: ruby,
                    ),
                  ),
                ),
                if (habitsToAdd.isNotEmpty)
                  SizedBox(
                    width: 16,
                  ),
                if (habitsToAdd.isNotEmpty)
                  Tooltip(
                    message: TooltipText.clickCheck,
                    child: FloatingActionButton(
                      heroTag: "Check",
                      onPressed: () {
                        BlocProvider.of<HabitsBloc>(context).add(AddHabits(habitsToAdd, DateTime.now(), widget.user.id!, close));
                      },
                      child: Icon(Icons.check),
                    ),
                  ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(24.0),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Welcome!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text(
                    "Select habits you'd like to track.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Don't worry, you can always add custom habits later.",
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Wrap(
                    children: items(),
                  ),
                  SizedBox(
                    height: kToolbarHeight,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
