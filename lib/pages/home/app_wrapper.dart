import 'package:daily_video_reminders/bloc/habits/habits.dart';
import 'package:daily_video_reminders/data/repositories/domain_repository.dart';
import 'package:daily_video_reminders/data/repositories/experience_repository.dart';
import 'package:daily_video_reminders/data/repositories/habit_entry_note_repository.dart';
import 'package:daily_video_reminders/data/repositories/habit_entry_repository.dart';
import 'package:daily_video_reminders/data/repositories/habit_repository.dart';
import 'package:daily_video_reminders/data/repositories/user_repository.dart';

import 'package:daily_video_reminders/pages/home/home_page.dart';
import 'package:daily_video_reminders/pages/home/user_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/multimedia/multimedia.dart';
import '../../bloc/user/user_bloc.dart';
import '../../data/repositories/multimedia_repository.dart';
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
      required this.habitEntryNoteRepository});

  final IUserRepository userRepository;
  final IMultimediaRepository multimediaRepository;
  final IDomainRepository domainRepository;
  final IExperienceRepository experienceRepository;
  final IHabitRepository habitRepository;
  final IHabitEntryRepository habitEntryRepository;
  final IHabitEntryNoteRepository habitEntryNoteRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => userRepository),
        RepositoryProvider(create: (context) => multimediaRepository),
        RepositoryProvider(create: (context) => domainRepository),
        RepositoryProvider(create: (context) => experienceRepository),
        RepositoryProvider(create: (context) => habitRepository),
        RepositoryProvider(create: (context) => habitEntryRepository),
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
  late HabitsBloc habitsBloc;
  @override
  void initState() {
    super.initState();
    userBloc = UserBloc(widget.userRepository, widget.habitRepository, widget.habitEntryRepository);
    multimediaBloc = MultimediaBloc(widget.multimediaRepository);
    habitsBloc = HabitsBloc(widget.habitRepository, widget.habitEntryRepository);
  }

  @override
  void dispose() {
    userBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => userBloc),
        BlocProvider(create: (context) => multimediaBloc),
        BlocProvider(create: (context) => habitsBloc),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        home: const UserPage(),
      ),
    );
  }
}