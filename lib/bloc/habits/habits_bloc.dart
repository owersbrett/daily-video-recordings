import 'package:habitbit/bloc/experience/experience.dart';
import 'package:habitbit/data/habit_entity.dart';
import 'package:habitbit/data/repositories/habit_entry_repository.dart';
import 'package:habitbit/data/repositories/habit_repository.dart';
import 'package:logging/logging.dart';
import 'package:habitbit/util/date_util.dart';

import '../../data/experience.dart';
import '../../data/frequency_type.dart';
import '../../data/habit.dart';
import '../../data/habit_entry.dart';
import '../../main.dart';
import 'habits.dart';

class HabitsBloc extends Bloc<HabitsEvent, HabitsState> {
  final IHabitRepository habitRepository;
  final IHabitEntryRepository habitEntryRepository;
  HabitsBloc(this.habitRepository, this.habitEntryRepository) : super(HabitsState.initial) {
    on<HabitsEvent>(_onEvent);
  }

  Future _onEvent(HabitsEvent event, Emitter<HabitsState> emit) async {
    if (event is FetchHabits) await _fetchHabits(event, emit);
    if (event is AddHabit) await _addHabit(event, emit);
    if (event is AddHabits) await _addHabits(event, emit);
    if (event is UpdateHabit) await _updateHabit(event, emit);
    if (event is DeleteHabit) await _deleteHabit(event, emit);
    if (event is UpdateHabitEntry) await _updateHabitEntry(event, emit);
  }

  Future _fetchHabits(FetchHabits event, Emitter<HabitsState> emit) async {
    try {
      DateTime now = event.currentDate;
      List<DateTime> interval = getInterval(now);
      Map<int, HabitEntity> habitEntities = await _getHabitEntries(event.userId, interval[0], interval[1]);
      var x = await habitEntryRepository.createHabitEntriesForDate(now);

      habitEntities = await _getHabitEntries(event.userId, interval[0], interval[1]);
      print(x);
      print(habitEntities);
      emit(HabitsLoaded(habitEntities, event.currentDate));
    } catch (e) {
      log(e.toString());
    }
  }

  List<DateTime> getInterval(DateTime now) {
    DateTime startInterval = DateUtil.startOfDay(now);
    DateTime endInterval = DateUtil.endOfDay(now);
    return [startInterval, endInterval];
  }

  Future<Map<int, HabitEntity>> _getHabitEntries(int userId, DateTime startInterval, DateTime endInterval) {
    return habitRepository.getHabitEntities(userId, startInterval, endInterval);
  }

  Future _backFillHabitEntries(DateTime day, List<Habit> habits) async {
    for (var habit in habits) {
      switch (habit.frequencyType) {
        case FrequencyType.daily:
          HabitEntry t = HabitEntry.fromHabit(habit, day);
          t = t.copyWith(updateDate: day, createDate: day);
          await habitEntryRepository.createIfDoesntExistForDate(t);
          break;
        case FrequencyType.everyOtherDay:
          HabitEntry t = HabitEntry.fromHabit(habit, day);
          t = t.copyWith(updateDate: day, createDate: day);
          await habitEntryRepository.createForTodayIfDoesntExistForYesterdayTodayOrTomorrow(t);
        case FrequencyType.weekly:
          // HabitEntry t = HabitEntry.fromHabit(habit, day);
          // t = t.copyWith(updateDate: day, createDate: day);
          // await habitEntryRepository.createForTodayIfDoesntExistBetweenStartDateAndEndDate(t, beginningOfSixDaysAgo, endOfSixDaysFromNow);
          break;
        default:
          log("FrequencyType not implemented: " + habit.frequencyType.toString());
      }
    }
  }

  Future _addHabits(AddHabits event, Emitter<HabitsState> emit) async {
    try {
      for (var element in event.habits) {
        Habit habit = element.copyWith(updateDate: event.dateToAddHabit, createDate: event.dateToAddHabit);
        habit = await habitRepository.create(habit);
        HabitEntry habitEntry = HabitEntry.fromHabit(habit, habit.createDate);
        habitEntry = habitEntry.copyWith(updateDate: event.dateToAddHabit, createDate: event.dateToAddHabit);
        await habitEntryRepository.createIfDoesntExistForDate(habitEntry);
      }

      Map<int, HabitEntity> habitEntities = await habitRepository.getHabitEntities(event.userId);

      emit(HabitsLoaded(habitEntities, state.currentDate));
      event.onClose?.call();
    } catch (e) {
      Logger.root.severe("Error adding habits: " + e.toString());
    }
  }

  Future _addHabit(AddHabit event, Emitter<HabitsState> emit) async {
    if (state is HabitsLoaded) {
      Habit habit = event.habit.copyWith(updateDate: event.dateToAddHabit, createDate: event.dateToAddHabit);
      habit = await habitRepository.create(habit);
      HabitEntry habitEntry = HabitEntry.fromHabit(habit, habit.createDate);
      habitEntry = habitEntry.copyWith(updateDate: event.dateToAddHabit, createDate: event.dateToAddHabit);
      await habitEntryRepository.createIfDoesntExistForDate(habitEntry);
      Map<int, HabitEntity> habitEntities = await habitRepository.getHabitEntities(event.habit.userId);

      emit(HabitsLoaded(habitEntities, state.currentDate));
    } else {
      Logger.root.severe("Error adding habit: " + event.habit.toString());
    }
  }

  Future _updateHabit(UpdateHabit event, Emitter<HabitsState> emit) async {
    if (state is HabitsLoaded) {
      await habitRepository.update(event.habit);
      Map<int, HabitEntity> habitEntities = await habitRepository.getHabitEntities(event.habit.userId);
      await validateHabitEntries(event.habit, habitEntities);
      emit(HabitsLoaded(habitEntities, state.currentDate));
    } else {
      Logger.root.severe("Error updating habit: " + event.habit.toString());
    }
  }

  Future validateHabitEntries(Habit habit, Map<int, HabitEntity> habitEntities) async {
    await habitEntryRepository.deleteWhere("habitId = ? AND createDate >= ?", [habit.id, state.currentDate.millisecondsSinceEpoch]);
    await _backFillHabitEntries(state.currentDate, state.habitsMap.values.toList());
  }

  Future _deleteHabit(DeleteHabit event, Emitter<HabitsState> emit) async {
    if (state is HabitsLoaded) {
      var loadedState = state as HabitsLoaded;
      Map<int, HabitEntity> habits = Map<int, HabitEntity>.from(loadedState.habitMap);
      HabitEntity? habitEntity = habits.remove(event.habit.id);
      if (habitEntity != null) {
        await habitRepository.delete(event.habit);
      }
      List<DateTime> intervals = getInterval(loadedState.currentDate);
      habits = await _getHabitEntries(event.userId, intervals[0], intervals[1]);
      emit(HabitsLoaded(habits, state.currentDate));
    } else {
      Logger.root.severe("Error deleting habit: " + event.habit.toString());
    }
  }

  Future _updateHabitEntry(UpdateHabitEntry event, Emitter<HabitsState> emit) async {
    if (state is HabitsLoaded) {
      await habitEntryRepository.update(event.habitEntry);
      Map<int, HabitEntity> habitEntities = Map<int, HabitEntity>.from(state.habitMap);
      HabitEntity entity = habitEntities[event.habit.id!]!.copyWith();
      List<HabitEntry> habitEntries = List<HabitEntry>.from(entity.habitEntries);

      habitEntries.removeWhere((element) => element.id == event.habitEntry.id);
      habitEntries.add(event.habitEntry);
      habitEntities[event.habit.id!] = entity.copyWith(habitEntries: habitEntries);
      if (event.habitEntry.booleanValue) {
        event.experienceBloc.add(ExperienceAdded(Experience.fromHabitEntry(event.habit, event.habitEntry)));
      } else {
        event.experienceBloc.add(ExperienceRemoved(Experience.fromHabitEntry(event.habit, event.habitEntry)));
      }
      emit(HabitsLoaded(habitEntities, state.currentDate));
    } else {
      Logger.root.severe("Error updating habit entry: " + event.habitEntry.toString());
    }
  }
}
