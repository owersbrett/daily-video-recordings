import 'package:habit_planet/util/date_util.dart';
import '../data/habit_entry.dart';

class HabitEntryUtil {
  static List<HabitEntry> backfillEntries(List<HabitEntry> entries, DateTime startDate, DateTime endDate) {
    List<HabitEntry> backfilledEntries = [];
    while (startDate.isBefore(endDate)) {
      if (entries.any((element) => DateUtil.isSameDay(element.createDate, startDate))){

      } else {
        backfilledEntries.add(entries.first.copyWith(createDate: startDate, updateDate: startDate, booleanValue: false));
      }
      startDate.add(Duration(days: 1)); 

    }
    return backfilledEntries;
  }
}
