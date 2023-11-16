import 'package:daily_video_reminders/bloc/experience/experience.dart';
import 'package:daily_video_reminders/data/habit_entity.dart';
import 'package:daily_video_reminders/data/repositories/habit_entry_repository.dart';
import 'package:daily_video_reminders/data/repositories/habit_repository.dart';
import 'package:logging/logging.dart';

import '../../data/experience.dart';
import '../../data/habit.dart';
import '../../data/habit_entry.dart';
import 'habits.dart';

class HabitsBloc extends Bloc<HabitsEvent, HabitsState> {
  final IHabitRepository habitRepository;
  final IHabitEntryRepository habitEntryRepository;
  HabitsBloc(this.habitRepository, this.habitEntryRepository) : super(HabitsState.initial) {
    on<HabitsEvent>(_onEvent);
  }

  Future _onEvent(HabitsEvent event, Emitter<HabitsState> emit) async {
    Logger.root.info("HabitsBloc: " + event.toString());

    if (event is FetchHabits) await _fetchHabits(event, emit);
    if (event is AddHabit) await _addHabit(event, emit);
    if (event is UpdateHabit) await _updateHabit(event, emit);
    if (event is DeleteHabit) await _deleteHabit(event, emit);
    if (event is UpdateHabitEntry) await _updateHabitEntry(event, emit);
    Logger.root.info("HabitsBloc: " + event.toString());
  }

  Future _fetchHabits(FetchHabits event, Emitter<HabitsState> emit) async {
    DateTime now = DateTime.now();
    Map<int, HabitEntity> habitEntities =
        await habitRepository.getHabitEntities(event.userId, now.subtract(const Duration(days: 3)), now.add(const Duration(days: 3)));
    List<Habit> habits = habitEntities.values.map((e) => e.habit).toList();
    List<HabitEntry> habitEntries = habitEntities.values.fold<List<HabitEntry>>([], (previousValue, element) {
      return [...previousValue, ...element.habitEntries];
    });

    List<HabitEntry> threeDaysAgoEntries =
        habitEntries.where((element) => element.createDate.day == now.subtract(const Duration(days: 3)).day).toList();
    List<HabitEntry> twoDaysAgoEntries =
        habitEntries.where((element) => element.createDate.day == now.subtract(const Duration(days: 2)).day).toList();
    List<HabitEntry> aDayAgoEntries = habitEntries.where((element) => element.createDate.day == now.subtract(const Duration(days: 1)).day).toList();
    List<HabitEntry> todaysEntries = habitEntries.where((element) => element.createDate.day == now.day).toList();
    List<HabitEntry> tomorrowEntries = habitEntries.where((element) => element.createDate.day == now.add(const Duration(days: 1)).day).toList();
    List<HabitEntry> twoDaysFromNowEntries = habitEntries.where((element) => element.createDate.day == now.add(const Duration(days: 2)).day).toList();
    List<HabitEntry> threeDaysFromNowEntries =
        habitEntries.where((element) => element.createDate.day == now.add(const Duration(days: 3)).day).toList();

    // await _backFillHabitEntries(3, habits, threeDaysAgoEntries);
    // await _backFillHabitEntries(2, habits, twoDaysAgoEntries);
    await _backFillHabitEntries(1, habits, aDayAgoEntries);
    // await _backFillHabitEntries(0, habits, todaysEntries);
    // await _backFillHabitEntries(-1, habits, tomorrowEntries);
    // await _backFillHabitEntries(-2, habits, twoDaysFromNowEntries);
    // await _backFillHabitEntries(-3, habits, threeDaysFromNowEntries);

    // habitEntities = await habitRepository.getHabitEntities(event.userId, now.subtract(const Duration(days: 3)), now.add(const Duration(days: 3)));

    emit(HabitsLoaded(habitEntities));
  }

  Future _backFillHabitEntries(int day, List<Habit> habits, List<HabitEntry> entries) async {
    // if you have less entries than habits, create entries for the missing habits
    // right now it's creating entries for all habits
    // TODO: only create entries for habits that don't have entries
    if (entries.length < habits.length) {
      for (var habit in habits) {
        HabitEntry t = HabitEntry.fromHabit(habit);
        DateTime updatedDate = DateTime.now().subtract(Duration(days: day));
        t = t.copyWith(updateDate: updatedDate, createDate: updatedDate);
        await habitEntryRepository.createIfDoesntExistForDate(t);
      }
    }
  }

  Future _addHabit(AddHabit event, Emitter<HabitsState> emit) async {
    if (state is HabitsLoaded) {
      Habit habit = await habitRepository.create(event.habit);
      HabitEntry habitEntry = HabitEntry.fromHabit(habit);
      habitEntry = await habitEntryRepository.create(habitEntry);
      Map<int, HabitEntity> habitEntities = await habitRepository.getHabitEntities(event.habit.userId);

      emit(HabitsLoaded(habitEntities));
    } else {
      Logger.root.severe("Error adding habit: " + event.habit.toString());
    }
  }

  Future _updateHabit(UpdateHabit event, Emitter<HabitsState> emit) async {}

  Future _deleteHabit(DeleteHabit event, Emitter<HabitsState> emit) async {
    if (state is HabitsLoaded) {
      var loadedState = state as HabitsLoaded;
      Map<int, HabitEntity> habits = Map<int, HabitEntity>.from(loadedState.habitMap);
      HabitEntity? habitEntity = habits.remove(event.habit.id);
      if (habitEntity != null) {
        await habitRepository.delete(event.habit);
      }
      emit(HabitsLoaded(habits));
    } else {
      Logger.root.severe("Error deleting habit: " + event.habit.toString());
    }
  }

  Future _updateHabitEntry(UpdateHabitEntry event, Emitter<HabitsState> emit) async {
    if (state is HabitsLoaded) {
      await habitEntryRepository.update(event.habitEntry);
      var habitEntities = await habitRepository.getHabitEntities(event.habit.userId);
      if (event.habitEntry.booleanValue) {
        event.experienceBloc.add(ExperienceAdded(Experience.fromHabitEntry(event.habit, event.habitEntry)));
      } else {
        event.experienceBloc.add(ExperienceRemoved(Experience.fromHabitEntry(event.habit, event.habitEntry)));
      }
      emit(HabitsLoaded(habitEntities));
    } else {
      Logger.root.severe("Error updating habit entry: " + event.habitEntry.toString());
    }
  }
}
