import 'package:daily_video_reminders/custom_progress_indicator.dart';
import 'package:daily_video_reminders/daily_app_bar.dart';
import 'package:daily_video_reminders/data/db.dart';
import 'package:daily_video_reminders/dropdown_chip.dart';
import 'package:daily_video_reminders/habit_card.dart';
import 'package:daily_video_reminders/habit_grid.dart';
import 'package:daily_video_reminders/navigation/navigation.dart';
import 'package:daily_video_reminders/pages/create_habit/create_habit_page.dart';
import 'package:daily_video_reminders/report_app_bar.dart';
import 'package:daily_video_reminders/pages/report/report_page.dart';
import 'package:daily_video_reminders/pages/settings/settings_page.dart';
import 'package:daily_video_reminders/pages/video/video_swipe_page.dart';
import 'package:daily_video_reminders/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../data/habit.dart';
import '../../data/habit_entry.dart';
import '../../widgets/weekday_hero.dart';
import '../video/video_upload_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  int pageIndex = 2;
  DateTime get now => DateTime.now();
  DateTime get yesterday => selectedDate.subtract(const Duration(days: 1));
  DateTime get tomorrow => selectedDate.add(const Duration(days: 1));
  
  DateTime get twoDaysAgo => yesterday.subtract(const Duration(days: 1));
  DateTime get twoDaysAhead => tomorrow.add(const Duration(days: 1));
  
  DateTime get threeDaysAgo => twoDaysAgo.subtract(const Duration(days: 1));
  DateTime get threeDaysAhead => twoDaysAhead.add(const Duration(days: 1));
  List<Widget> get days => [
        wdh(threeDaysAgo, 12),
        wdh(twoDaysAgo, 40),
        wdh(yesterday, 50),
        wdh(selectedDate, 100),
        wdh(tomorrow, 80),
        wdh(twoDaysAhead, 100),
        wdh(threeDaysAhead, 54)
      ];

  Widget wdh(DateTime weekdayDate, int score) => GestureDetector(
    onTap: (){
      setState(() {
        selectedDate = weekdayDate;
      });
    },
    child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: WeekdayHero(
            date: weekdayDate,
            score: score,
            expanded: weekdayDate == selectedDate,
            key: ValueKey(weekdayDate.day),
          ),
        ),
  );
  List<Widget> habits =
      Database.habits.map((e) => HabitCard(habit: e)).toList();

  Widget _body() {
    if (pageIndex == 0) {
      return Center(
        child: SettingsPage(),
      );
    } else if (pageIndex == 1) {
      return ReportPage(
        habitGridData: habitGridData,
      );
    } else if (pageIndex == 2) {
      return Center(
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
      ));
    } else if (pageIndex == 3) {
      return Center(child: VideoUploadPage());
    } else if (pageIndex == 4) {
      return VideoSwipePage();
    } else {
      return Center(
        child: Text("Error"),
      );
    }
  }

  Map<int, List<HabitEntry>> get habitGridData {
    Map<int, List<HabitEntry>> habitEntries = <int, List<HabitEntry>>{};
    for (var element in Database.habits) {
      habitEntries[element.id] = [];
    }
    for (var element in Database.habitEntries) {
      habitEntries[element.habitId]!.add(element);
    }
    return habitEntries;
  }

  Widget get appBarTitle {
    if (pageIndex == 0) {
      return Text("Settings");
    } else if (pageIndex == 1) {
      return ReportAppBar();
    } else if (pageIndex == 2) {
      return DailyAppBar();
    } else if (pageIndex == 3) {
      return Text("");
      // return Text("Upload Video");
    } else if (pageIndex == 4) {
      return Text("Watch");
    } else {
      return Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: appBarTitle,
      ),
      body: _body(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() => pageIndex = value),
        currentIndex: pageIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor:
            Theme.of(context).colorScheme.surfaceVariant.withOpacity(.3),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Reports'),
          BottomNavigationBarItem(
            icon: Icon(Icons.repeat),
            label: 'Daily',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.video_call), label: 'Video'),
          BottomNavigationBarItem(
              icon: Icon(Icons.remove_red_eye), label: 'Watch'),
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
      child: Icon(CupertinoIcons.add, color: emeraldDark,),
      onPressed: () {
        Navigation.createRoute(CreateHabitPage(),  context, AnimationEnum.pageAscend);
        // Handle the plus icon action
      },
    );
  }
}
