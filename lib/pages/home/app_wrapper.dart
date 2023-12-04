import 'package:habitbit/bloc/experience/experience.dart';
import 'package:habitbit/bloc/habits/habits.dart';
import 'package:habitbit/bloc/reports/reports.dart';
import 'package:habitbit/data/repositories/domain_repository.dart';
import 'package:habitbit/data/repositories/experience_repository.dart';
import 'package:habitbit/data/repositories/habit_entry_note_repository.dart';
import 'package:habitbit/data/repositories/habit_entry_repository.dart';
import 'package:habitbit/data/repositories/habit_repository.dart';
import 'package:habitbit/data/repositories/user_repository.dart';

import 'package:habitbit/pages/home/user_page.dart';

import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import '../../bloc/multimedia/multimedia.dart';
import '../../bloc/user/user_bloc.dart';
import '../../data/repositories/multimedia_repository.dart';
import '../../service/analytics_service.dart';
import '../../theme/theme.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper(
      {super.key,
      required this.userRepository,
      required this.multimediaRepository,
      required this.domainRepository,
      required this.experienceRepository,
      required this.habitRepository,
      required this.habitEntryRepository,
      required this.habitEntryNoteRepository,
      required this.db,
      required this.analyticsService});

  final Database db;
  final IUserRepository userRepository;
  final IMultimediaRepository multimediaRepository;
  final IDomainRepository domainRepository;
  final IExperienceRepository experienceRepository;
  final IHabitRepository habitRepository;
  final IHabitEntryRepository habitEntryRepository;
  final IAnalyticsService analyticsService;
  final IHabitEntryNoteRepository habitEntryNoteRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => userRepository),
        RepositoryProvider(create: (context) => multimediaRepository),
        RepositoryProvider(create: (context) => domainRepository),
        RepositoryProvider(create: (context) => experienceRepository),
        RepositoryProvider(create: (context) => db),
        RepositoryProvider(create: (context) => habitRepository),
        RepositoryProvider(create: (context) => habitEntryRepository),
        RepositoryProvider(create: (context) => analyticsService),
        RepositoryProvider(create: (context) => habitEntryNoteRepository),
      ],
      child: DailyVideoReminders(
        userRepository: userRepository,
        multimediaRepository: multimediaRepository,
        domainRepository: domainRepository,
        experienceRepository: experienceRepository,
        habitRepository: habitRepository,
        habitEntryRepository: habitEntryRepository,
        habitEntryNoteRepository: habitEntryNoteRepository,
      ),
    );
  }
}

class DailyVideoReminders extends StatefulWidget {
  const DailyVideoReminders({
    super.key,
    required this.userRepository,
    required this.multimediaRepository,
    required this.domainRepository,
    required this.experienceRepository,
    required this.habitRepository,
    required this.habitEntryRepository,
    required this.habitEntryNoteRepository,
  });
  final IUserRepository userRepository;
  final IMultimediaRepository multimediaRepository;
  final IDomainRepository domainRepository;
  final IExperienceRepository experienceRepository;
  final IHabitRepository habitRepository;
  final IHabitEntryRepository habitEntryRepository;
  final IHabitEntryNoteRepository habitEntryNoteRepository;

  @override
  State<DailyVideoReminders> createState() => _DailyVideoRemindersState();
}

class _DailyVideoRemindersState extends State<DailyVideoReminders> {
  late UserBloc userBloc;
  late MultimediaBloc multimediaBloc;
  late ReportsBloc reportsBloc;
  late HabitsBloc habitsBloc;
  late ExperienceBloc experienceBloc;
  @override
  void initState() {
    super.initState();
    userBloc = UserBloc(widget.userRepository, widget.habitRepository, widget.habitEntryRepository, widget.experienceRepository);
    multimediaBloc = MultimediaBloc(widget.multimediaRepository);
    habitsBloc = HabitsBloc(widget.habitRepository, widget.habitEntryRepository);
    experienceBloc = ExperienceBloc(widget.experienceRepository);
    reportsBloc = ReportsBloc(widget.habitRepository);
  }

  @override
  void dispose() {
    reportsBloc.close();
    userBloc.close();
    multimediaBloc.close();
    habitsBloc.close();
    experienceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => userBloc),
        BlocProvider(create: (context) => multimediaBloc),
        BlocProvider(create: (context) => reportsBloc),
        BlocProvider(create: (context) => habitsBloc),
        BlocProvider(create: (context) => experienceBloc),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Habitbit',
        theme: theme,
        home: const UserPage(),
      ),
    );
  }
}
