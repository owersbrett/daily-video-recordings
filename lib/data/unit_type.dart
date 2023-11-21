import 'package:mementoh/util/string_util.dart';

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
      'unitType': toString(),
    };
  }

  static UnitType fromMap(Map<String, dynamic> map) {
    return UnitType.values.firstWhere((element) => element.toString() == map['unitType']);
  }

  String toPrettyString() {
    return StringUtil.capitalize(toString().split('.').last);
  }

  static UnitType fromPrettyString(String prettyString) {
    return UnitType.values.firstWhere((element) => element.toPrettyString().toLowerCase() == prettyString.toLowerCase());
  }
}
