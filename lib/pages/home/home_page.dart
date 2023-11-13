import 'package:camera/camera.dart';
import 'package:daily_video_reminders/daily_app_bar.dart';
import 'package:daily_video_reminders/data/bottom_sheet_state.dart';
import 'package:daily_video_reminders/data/db.dart';
import 'package:daily_video_reminders/habit_grid.dart';
import 'package:daily_video_reminders/navigation/navigation.dart';
import 'package:daily_video_reminders/pages/create_habit/create_habit_page.dart';
import 'package:daily_video_reminders/pages/home/home_page_bottom.dart';
import 'package:daily_video_reminders/pages/home/week_and_habits_scroll_view.dart';
import 'package:daily_video_reminders/pages/video/record_video_page.dart';
import 'package:daily_video_reminders/report_app_bar.dart';
import 'package:daily_video_reminders/pages/report/report_page.dart';
import 'package:daily_video_reminders/pages/settings/settings_page.dart';
import 'package:daily_video_reminders/pages/video/video_swipe_page.dart';
import 'package:daily_video_reminders/theme/theme.dart';
import 'package:flutter/material.dart';
import '../../data/habit_entity.dart';
import '../../data/habit_entry.dart';
import '../../main.dart';
import '../video/video_preview_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  bool showCreateDropdown = false;
  int pageIndex = 2;
  BottomSheetState bottomSheetState = BottomSheetState.hidden;

  Widget _body(BuildContext context) {
    if (pageIndex == 0) {
      return Center(
        child: SettingsPage(),
      );
    } else if (pageIndex == 1) {
      return ReportPage(
        habitGridData: habitGridData,
      );
    } else if (pageIndex == 2) {
      return WeekAndHabitsScrollView(
        todaysHabitEntities: Database.habits.map((e) => HabitEntity(e, Database.habitEntries)).toList(),
        weekOfHabitEntities: [[], [], [], [], [], [], []],
        currentDay: DateTime.now(),
      );
    } else if (pageIndex == 3) {
      return VideoPreviewPage();
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
      return DailyAppBar(
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
      );
    } else if (pageIndex == 3) {
      return DailyAppBar(
          icon: IconButton(
        icon: Icon(Icons.add_circle),
        iconSize: 32,
        color: Colors.black,
        onPressed: () {
          setState(() {
            showCreateDropdown = true;
          });
        },
      ));
    } else if (pageIndex == 4) {
      return Text("");
    } else {
      return Text("Error");
    }
  }

  Widget get bars => GestureDetector(
        onDoubleTap: () {
          log("double tapped");
          setState(() {
            if (bottomSheetState == BottomSheetState.hidden) {
              bottomSheetState = BottomSheetState.expanded;
            } else {
              bottomSheetState = BottomSheetState.hidden;
            }
          });
        },
        onTap: () {
          log("Tapped");
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
        child: HomePageBottom(
          value1: 0.3,
          value2: 0.5,
          value3: 0.7,
          value4: 0.2,
          value5: 0.4,
          value6: 0.6,
          bottomSheetState: bottomSheetState,
        ),
      );

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
              Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: appBarTitle,
                ),
                body: _body(context),
                bottomSheet: bottomBar(context),

                // bottomNavigationBar: bottomBar(context),
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
                  InkWell(
                    onTap: () {
                      setState(() {
                        showCreateDropdown = false;
                      });
                      Navigation.createRoute(CreateHabitPage(), context, AnimationEnum.pageAscend);
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
                      Navigation.createRoute(HabitGrid(
                        habits: habitGridData,
                      ), context, AnimationEnum.pageAscend);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download_rounded),
                          SizedBox(
                            width: 4,
                          ),
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

  Widget bottomBar(BuildContext context) {
    return bars;
    return BottomNavigationBar(
      onTap: (value) => setState(() => pageIndex = value),
      currentIndex: pageIndex,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.3),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Reports'),
        BottomNavigationBarItem(
          icon: Icon(Icons.repeat),
          label: 'Daily',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.video_call), label: 'Video'),
        BottomNavigationBarItem(icon: Icon(Icons.remove_red_eye), label: 'Watch'),
      ],
    );
  }
}
