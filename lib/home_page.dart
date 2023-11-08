import 'package:daily_video_reminders/data/db.dart';
import 'package:daily_video_reminders/dropdown_chip.dart';
import 'package:daily_video_reminders/habit_card.dart';
import 'package:daily_video_reminders/today_widget.dart';
import 'package:daily_video_reminders/weekday_hero.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime threeDaysAgo = DateTime.now().subtract(Duration(days: 3));
  DateTime twoDaysAgo = DateTime.now().subtract(Duration(days: 2));
  DateTime oneDayAgo = DateTime.now().subtract(Duration(days: 1));
  DateTime now = DateTime.now();
  DateTime oneDayFromNow = DateTime.now().add(Duration(days: 1));
  DateTime twoDaysFromNow = DateTime.now().add(Duration(days: 2));
  DateTime threeDaysFromNow = DateTime.now().add(Duration(days: 3));
  List<Widget> get days => [
        wdh(threeDaysAgo, 75),
        wdh(twoDaysAgo, 77),
        wdh(oneDayAgo, 50),
        wdh(now, 75),
        wdh(oneDayFromNow, 0),
        wdh(twoDaysFromNow, 0),
        wdh(threeDaysFromNow, 0)
      ];

  Widget wdh(DateTime date, int score) => Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: WeekdayHero(date: date, score: score, expanded: date == now),
      );
  List<Widget> habits =
      Database.habits.map((e) => HabitCard(habit: e)).toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: TodayWidget(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: days,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Expanded(
              child: ListView(children: habits),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class CupertinoIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Icon(CupertinoIcons.add),
      onPressed: () {
        // Handle the plus icon action
      },
    );
  }
}
