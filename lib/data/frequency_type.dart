import 'package:habit_planet/util/string_util.dart';

enum FrequencyType {
  // once,
  daily,
  everyOtherDay,
  // everyThreeDays,
  // everyFourDays,
  // everyFiveDays,
  // everySixDays,
  weekly,
  // twoDaysOnOneDayOff,
  // biweekly,
  // monthly,
  // yearly,
  ;

  Map<String, dynamic> toMap() {
    return {
      'frequencyType': toString(),
    };
  }

  static FrequencyType fromMap(Map<String, dynamic> map) {
    return FrequencyType.values.firstWhere((element) => element.toString() == map['frequencyType']);
  }

  String toPrettyString() {
    return StringUtil.capitalize(toString().split('.').last);
  }

  static FrequencyType fromPrettyString(String prettyString) {
    return FrequencyType.values.firstWhere((element) => element.toPrettyString().toLowerCase() == prettyString.toLowerCase());
  }

  String toUiString() {
    switch (this) {
      // case FrequencyType.once:
      //   return 'Once';
      case FrequencyType.daily:
        return 'Daily';
      case FrequencyType.everyOtherDay:
        return 'Every Other Day';
      // case FrequencyType.everyThreeDays:
      //   return 'One Day On, Two Days Off';
      // case FrequencyType.everyFourDays:
      //   return 'One Day On, Three Days Off';
      // case FrequencyType.everyFiveDays:
      //   return 'One Day On, Three Days Off';
      // case FrequencyType.everySixDays:
      //   return 'One Day On, Three Days Off';
      // case FrequencyType.twoDaysOnOneDayOff:
      //   return 'Two Days On, One Day Off';
      case FrequencyType.weekly:
        return 'Weekly';
      // ... handle other cases
      default:
        return 'Unknown';
    }
  }
}
