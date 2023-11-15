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

    Map<int, HabitEntity> habitEntities = await habitRepository.getHabitEntities(event.userId);

    emit(HabitsLoaded(habitEntities));
  }

  Future _addHabit(AddHabit event, Emitter<HabitsState> emit) async {
    if (state is HabitsLoaded) {
      Habit habit = await habitRepository.create(event.habit);
      HabitEntry habitEntry = HabitEntry.fromHabit(habit);
      habitEntry = await habitEntryRepository.create(habitEntry);
      HabitEntity habitEntity = HabitEntity(habit: habit, habitEntries: [habitEntry], habitEntryNotes: []);
      var loadedState = state as HabitsLoaded;
      Map<int, HabitEntity> habits = Map<int, HabitEntity>.from(loadedState.habitMap);
      habits.putIfAbsent(habit.id!, () => habitEntity);

      emit(HabitsLoaded(habits));
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
      var loadedState = state as HabitsLoaded;
      Map<int, HabitEntity> habits = Map<int, HabitEntity>.from(loadedState.habitMap);
      HabitEntity? habitEntity = habits[event.habit.id];
      if (habitEntity != null) {
        HabitEntry habitEntry = habitEntity.habitEntries.firstWhere((element) => element.id == event.habitEntry.id, orElse: () => HabitEntry.empty());
        if (!habitEntry.isEmpty) {

          await habitEntryRepository.update(event.habitEntry);
          habitEntry = await habitEntryRepository.getById(event.habit.id!);
          habitEntity.habitEntries.removeWhere((element) => element.id == habitEntry.id);
          habitEntity.habitEntries.add(habitEntry);
          habits.update(event.habit.id!, (value) => habitEntity);
          event.experienceBloc.add(ExperienceAdded(Experience.fromHabitEntry(habitEntity.habit, habitEntry)));
          emit(HabitsLoaded(habits));
        }
      }
    } else {
      Logger.root.severe("Error updating habit entry: " + event.habitEntry.toString());
    }
  }
}
