import 'package:mementoh/util/string_util.dart';

enum FrequencyType {
  // once,
  daily,
  everyOtherDay,
  weekly,
  // biweekly,
  // monthly,
  // yearly,
  ;

  Map<String, dynamic> toMap() {
    return {
      'frequencyType': this.toString(),
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
      case FrequencyType.daily:
        return 'Daily';
      case FrequencyType.everyOtherDay:
        return 'Every Other Day';
      case FrequencyType.weekly:
        return 'Weekly';
      // ... handle other cases
      default:
        return 'Unknown';
    }
  }
}
