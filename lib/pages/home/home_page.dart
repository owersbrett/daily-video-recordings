// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:mementoh/service/media_service.dart';
import 'package:flutter/material.dart';

import 'package:mementoh/daily_app_bar.dart';
import 'package:mementoh/data/bottom_sheet_state.dart';
import 'package:mementoh/data/db.dart';
import 'package:mementoh/habit_grid.dart';
import 'package:mementoh/navigation/navigation.dart';
import 'package:mementoh/pages/create_habit/create_a_habit.dart';
import 'package:mementoh/pages/home/home_page_bottom.dart';
import 'package:mementoh/pages/home/now_data.dart';
import 'package:mementoh/pages/home/week_and_habits_scroll_view.dart';
import 'package:mementoh/pages/video/record_video_page.dart';

import '../../bloc/experience/experience.dart';
import '../../bloc/habits/habits.dart';
import '../../data/habit_entity.dart';
import '../../data/habit_entry.dart';
import '../../data/user.dart';
import '../../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});
  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  NowData nowData = NowData();

  bool showCreateDropdown = false;
  BottomSheetState bottomSheetState = BottomSheetState.hidden;
  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), minuteFunction);
    log(monthlyValue.toString());
    log("Oi mate");
    BlocProvider.of<HabitsBloc>(context).add(FetchHabits(widget.user.id!, DateTime.now()));
  }

  void minuteFunction(Timer t) {
    setState(() {
      if (nowData.currentTime.difference(nowData.startTime).inHours > 1) {
        nowData.timeLimitReached();
      }
      nowData.elapsedTime = nowData.currentTime.difference(nowData.startTime);
      nowData.currentTime = DateTime.now();
    });
  }

  DateTime get now => nowData.currentTime;

  double get monthlyValue => nowData.currentTime.day / DateTime(now.year, now.month + 1, 0).subtract(Duration(days: 1)).day;
  double get annualValue => nowData.dayOfYearFraction;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Map<int, List<HabitEntry>> get habitGridData {
    Map<int, List<HabitEntry>> habitEntries = <int, List<HabitEntry>>{};
    for (var element in CustomDatabase.habits) {
      habitEntries[element.id!] = [];
    }
    for (var element in CustomDatabase.habitEntries) {
      habitEntries[element.habitId]!.add(element);
    }
    return habitEntries;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (showCreateDropdown) {
              setState(() {
                showCreateDropdown = false;
              });
            }
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              BlocBuilder<HabitsBloc, HabitsState>(
                builder: (context, state) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      title: DailyAppBar(
                        icon: IconButton(
                          icon: Icon(Icons.add_circle),
                          iconSize: 32,
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              showCreateDropdown = true;
                            });
                          },
                        ),
                      ),
                    ),
                    body: WeekAndHabitsScrollView(habitsState: state),
                    bottomSheet: bottomBar(context, state),

                    // bottomNavigationBar: bottomBar(context),
                  );
                },
              ),
            ],
          ),
        ),
        Visibility(
          visible: showCreateDropdown,
          child: Positioned(
            right: 48,
            top: kToolbarHeight * 1.75,
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              elevation: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder<HabitsBloc, HabitsState>(
                    builder: (context, state) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            showCreateDropdown = false;
                          });
                          Navigation.createRoute(CreateHabitPage(dateToAddHabit: state.currentDate), context, AnimationEnum.pageAscend);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_circle),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "Habit",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    width: 100,
                    height: 2,
                    color: Colors.grey.withOpacity(.2),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showCreateDropdown = false;
                      });
                      Navigation.createRoute(
                          RecordVideoPage(camera: cameras.firstWhere((element) => element.lensDirection == CameraLensDirection.front)),
                          context,
                          AnimationEnum.pageAscend);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.video_call_rounded),
                          SizedBox(
                            width: 4,
                          ),
                          Text("Video", style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 2,
                    color: Colors.grey.withOpacity(.2),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showCreateDropdown = false;
                      });
                      Navigation.createRoute(
                          HabitGrid(
                            habits: habitGridData,
                          ),
                          context,
                          AnimationEnum.pageAscend);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download_rounded),
                          SizedBox(width: 4),
                          Text("Report", style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget bottomBar(BuildContext context, HabitsState state) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (bottomSheetState == BottomSheetState.hidden) {
            bottomSheetState = BottomSheetState.collapsed;
          } else if (bottomSheetState == BottomSheetState.collapsed) {
            bottomSheetState = BottomSheetState.expanded;
          } else if (bottomSheetState == BottomSheetState.expanded) {
            bottomSheetState = BottomSheetState.hidden;
          }
        });
      },
      child: BlocBuilder<ExperienceBloc, ExperienceState>(
        builder: (context, experienceState) {
          Map<int, List<HabitEntity>> thisWeeksHabitsSeperated = state.segregatedHabits();
          List<HabitEntity> thisWeeksHabitsTogether = [];
          thisWeeksHabitsSeperated.forEach((key, value) {
            thisWeeksHabitsTogether.addAll(value);
          });
          var percentageForToday = state.todaysCompletionPercentage;
          log(percentageForToday.toString());
          var percentageForTheWeek = state.weeksCompletionPercentage;
          log(percentageForTheWeek.toString());
          var percentageToNextLevel = experienceState.percentageToNextLevel();

          return HomePageBottom(
            value1: percentageForToday,
            value2: percentageForTheWeek,
            value3: percentageToNextLevel,
            value4: nowData.currentTime.second / 60,
            value5: monthlyValue,
            value6: annualValue,
            nowData: nowData,
            bottomSheetState: bottomSheetState,
            onStartTimer: () {
              setState(() {
                nowData.startTimerTimer = DateTime.now();
              });
            },
          );
        },
      ),
    );
  }
}
