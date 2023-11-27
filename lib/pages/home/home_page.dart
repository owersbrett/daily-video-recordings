// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:mementohr/pages/report/report_page.dart';
import 'package:flutter/material.dart';

import 'package:mementohr/widgets/daily_app_bar.dart';
import 'package:mementohr/data/bottom_sheet_state.dart';
import 'package:mementohr/data/db.dart';
import 'package:mementohr/navigation/navigation.dart';
import 'package:mementohr/pages/create_habit/create_a_habit.dart';
import 'package:mementohr/pages/home/home_page_bottom.dart';
import 'package:mementohr/pages/home/now_data.dart';
import 'package:mementohr/pages/home/week_and_habits_scroll_view.dart';
import 'package:mementohr/pages/video/record_video_page.dart';

import '../../bloc/experience/experience.dart';
import '../../bloc/habits/habits.dart';
import '../../data/habit_entity.dart';
import '../../data/habit_entry.dart';
import '../../data/user.dart';
import '../../main.dart';
import '../../tooltip_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});
  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  bool showCreateDropdown = false;
  BottomSheetState bottomSheetState = BottomSheetState.hidden;
  @override
  void initState() {
    super.initState();

    BlocProvider.of<HabitsBloc>(context).add(FetchHabits(widget.user.id!, DateTime.now()));
  }



  Map<int, List<HabitEntry>> habitGridData() {
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
                        currentDate: state.currentDate,
                        icon: IconButton(
                          icon: Tooltip(
                            message: TooltipText.clickAdd,
                            child: Icon(Icons.add_circle),
                          ),
                          iconSize: 32,
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              showCreateDropdown = !showCreateDropdown;
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
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              elevation: 10,
              child: BlocBuilder<HabitsBloc, HabitsState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Tooltip(
                        message: TooltipText.clickReports,
                        child: InkWell(
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
                                const Icon(
                                  Icons.add_circle,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Habit",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 2,
                        color: Colors.grey.withOpacity(.2),
                      ),
                      Tooltip(
                        message: TooltipText.clickReports,
                        child: InkWell(
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
                                const Icon(Icons.video_call_rounded, color: Colors.black),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Video",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 2,
                        color: Colors.grey.withOpacity(.2),
                      ),
                      Tooltip(
                        message: TooltipText.clickReports,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              showCreateDropdown = false;
                            });
                            Navigation.createRoute(const ReportPage(), context, AnimationEnum.pageAscend);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.download_rounded, color: Colors.black),
                                const SizedBox(width: 4),
                                Text(
                                  "Report",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  void setBottomSheetState() {
    setState(() {
      if (bottomSheetState == BottomSheetState.hidden) {
        bottomSheetState = BottomSheetState.collapsed;
      } else if (bottomSheetState == BottomSheetState.collapsed) {
        bottomSheetState = BottomSheetState.expanded;
      } else if (bottomSheetState == BottomSheetState.expanded) {
        bottomSheetState = BottomSheetState.hidden;
      }
    });
  }

  Widget bottomBar(BuildContext context, HabitsState state) {
    return BlocBuilder<ExperienceBloc, ExperienceState>(
      builder: (context, experienceState) {
        Map<int, List<HabitEntity>> thisWeeksHabitsSeperated = state.segregatedHabits();
        List<HabitEntity> thisWeeksHabitsTogether = [];
        thisWeeksHabitsSeperated.forEach((key, value) {
          thisWeeksHabitsTogether.addAll(value);
        });
        var percentageForToday = state.todaysCompletionPercentage;
        var percentageForTheWeek = state.weeksCompletionPercentage;
        var percentageToNextLevel = experienceState.percentageToNextLevel();

        return HomePageBottom(
          value1: percentageForToday,
          value2: percentageForTheWeek,
          value3: percentageToNextLevel,
          bottomSheetState: bottomSheetState,
          setBottomSheetState: setBottomSheetState,
        );
      },
    );
  }
}
