import 'package:daily_video_reminders/util/StringUtil.dart';

enum UnitType {
  fluidOunce,
  actions,
  time,
  words,
  count,
  prep,
  learn,
  boolean,
  distance,
  minutes,
  weight,
  reps,
  sets,
  blank,
  pages,
  other;

  Map<String, dynamic> toMap() {
    return {
      'unitType': this.toString(),
    };
  }

  static UnitType fromMap(Map<String, dynamic> map) {
    return UnitType.values
        .firstWhere((element) => element.toString() == map['unitType']);
  }

  String toPrettyString() {
    return StringUtil.capitalize(toString().split('.').last);
  }
}
