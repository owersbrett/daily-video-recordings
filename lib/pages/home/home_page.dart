// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:habit_planet/pages/report/report_page.dart';
import 'package:flutter/material.dart';
import 'package:habit_planet/theme/theme.dart';

import 'package:habit_planet/widgets/daily_app_bar.dart';
import 'package:habit_planet/data/bottom_sheet_state.dart';
import 'package:habit_planet/data/db.dart';
import 'package:habit_planet/navigation/navigation.dart';
import 'package:habit_planet/pages/create_habit/create_a_habit.dart';
import 'package:habit_planet/pages/home/home_page_bottom.dart';
import 'package:habit_planet/pages/home/now_data.dart';
import 'package:habit_planet/pages/home/week_and_habits_scroll_view.dart';
import 'package:habit_planet/pages/video/record_video_page.dart';
import 'package:habit_planet/widgets/level_up_overlay.dart';

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
  bool hasShownLevelUp = false;
  bool showCreateDropdown = false;
  BottomSheetState bottomSheetState = BottomSheetState.hidden;
  int recentLevel = 1;
  bool levelUp = false;
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
                        icon: Container(
                          decoration: !showCreateDropdown
                              ? null
                              : BoxDecoration(
                                  color: Colors.grey[300], // Adjust the button color as needed
                                  borderRadius: BorderRadius.circular(16), // Adjust the border radius as needed

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(1), // Shadow color
                                      offset: Offset(-2, 2),
                                      blurRadius: 6, // Shadow blur radius
                                      spreadRadius: -3, // Negative spread radius to create inset effect
                                    ),
                                    BoxShadow(
                                      offset: Offset(1, 1),
                                      color: Colors.black.withOpacity(0.2), // Shadow color

                                      blurRadius: 6, // Shadow blur radius
                                      spreadRadius: -3, // Negative spread radius to create inset effect
                                    ),
                                  ],
                                ),
                          child: FloatingActionButton.small(
                            backgroundColor: showCreateDropdown ? Colors.transparent : Colors.white,
                            foregroundColor: emerald,
                            heroTag: "Add Circle",
                            elevation: showCreateDropdown ? 0 : 3,
                            onPressed: () {
                              if (!showCreateDropdown) HapticFeedback.mediumImpact();
                              setState(() {
                                showCreateDropdown = !showCreateDropdown;
                              });
                            },
                            child: Tooltip(
                              message: TooltipText.clickAdd,
                              child: Icon(Icons.add_circle),
                            ),
                          ),
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
                            HapticFeedback.selectionClick();
                            Navigation.createRoute(CreateHabitPage(dateToAddHabit: state.currentDate), context, AnimationEnum.pageAscend);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.add_circle,
                                  color: emerald,
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
                            HapticFeedback.selectionClick();
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
                                const Icon(Icons.video_call_rounded, color: emerald),
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
                            HapticFeedback.selectionClick();
                            Navigation.createRoute(const ReportPage(), context, AnimationEnum.pageAscend);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.download_rounded, color: emerald),
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
