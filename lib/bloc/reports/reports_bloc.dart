import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:habitbit/bloc/reports/reports.dart';

import '../../data/habit_entity.dart';
import '../../data/habit_entry.dart';
import '../../data/repositories/habit_repository.dart';
import '../../data/unit_type.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final IHabitRepository habitRepository;
  ReportsBloc(this.habitRepository) : super(ReportsInitial()) {
    on<ReportsEvent>(_onEvent);
  }

  Future _onEvent(ReportsEvent event, Emitter<ReportsState> emit) async {
    if (event is FetchReports) await _fetchReports(event, emit);
  }

  Future<Map<int, HabitEntity>> _getHabitEntities(int userId, DateTime startInterval, DateTime endInterval) {
    return habitRepository.getHabitEntities(userId, startInterval, endInterval);
  }

  Future _fetchReports(FetchReports event, Emitter<ReportsState> emit) async {
    try {
      emit(ReportsLoading());
      Map<int, HabitEntity> entities = await _getHabitEntities(event.userId, event.startInterval, event.endInterval);

      Map<int, HabitEntity> fullEntities = _fillMissingEntities(entities, event.startInterval, event.endInterval);

      emit(ReportsLoaded(fullEntities, event.startInterval, event.endInterval));
    } catch (e) {
      emit(ReportsError());
    }
  }

  Map<int, HabitEntity> _fillMissingEntities(Map<int, HabitEntity> entities, DateTime startInterval, DateTime endInterval) {
    Map<int, HabitEntity> fullEntities = {};
    for (var entity in entities.values) {
      fullEntities[entity.habit.id!] = _fillMissingEntity(entity, startInterval, endInterval);
    }
    return fullEntities;
  }

  HabitEntity _fillMissingEntity(HabitEntity entity, DateTime startInterval, DateTime endInterval) {
    List<DateTime> weekDates = List.generate(
      7,
      (index) => startInterval.add(Duration(days: index)),
    );

    // Creating a map for quick lookup
    Map<DateTime, HabitEntry> entryMap = {
      for (var entry in entity.habitEntries) DateTime(entry.createDate.year, entry.createDate.month, entry.createDate.day): entry
    };

    for (var element in weekDates) {
      if (!entryMap.containsKey(element)) {
        entryMap[element] = HabitEntry(
          id: null,
          habitId: entity.habit.id!,
          createDate: element,
          booleanValue: false,
          unitType: UnitType.boolean,
          updateDate: element,
        );
      }
    }
    entity = entity.copyWith(habitEntries: entryMap.values.toList());

    return entity;
  }
}
