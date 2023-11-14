import 'dart:async';

import 'package:camera/camera.dart';
import 'package:daily_video_reminders/daily_app_bar.dart';
import 'package:daily_video_reminders/data/bottom_sheet_state.dart';
import 'package:daily_video_reminders/data/db.dart';
import 'package:daily_video_reminders/data/multimedia.dart';
import 'package:daily_video_reminders/data/repositories/user_repository.dart';
import 'package:daily_video_reminders/habit_grid.dart';
import 'package:daily_video_reminders/navigation/navigation.dart';
import 'package:daily_video_reminders/pages/create_habit/create_habit_page.dart';
import 'package:daily_video_reminders/pages/home/home_page.dart';
import 'package:daily_video_reminders/pages/home/home_page_bottom.dart';
import 'package:daily_video_reminders/pages/home/now_data.dart';

import 'package:daily_video_reminders/pages/home/week_and_habits_scroll_view.dart';
import 'package:daily_video_reminders/pages/video/record_video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/habit_entity.dart';
import '../../data/habit_entry.dart';
import '../../data/repositories/multimedia_repository.dart';
import '../../main.dart';
import '../video/video_preview_page.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key, required this.userRepository, required this.multimediaRepository});

  final IUserRepository userRepository;
  final IMultimediaRepository multimediaRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => userRepository),
        RepositoryProvider(create: (context) => multimediaRepository),
      ],
      child: DailyVideoReminders(
        userRepository: userRepository,
        multimediaRepository: multimediaRepository,
      ),
    );
  }
}

class DailyVideoReminders extends StatefulWidget {
  const DailyVideoReminders({super.key, required this.userRepository, required this.multimediaRepository});
  final IUserRepository userRepository;
  final IMultimediaRepository multimediaRepository;

  @override
  State<DailyVideoReminders> createState() => _DailyVideoRemindersState();
}

class _DailyVideoRemindersState extends State<DailyVideoReminders> {
  late UserBloc userBloc;
  late MultimediaBloc multimediaBloc;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
