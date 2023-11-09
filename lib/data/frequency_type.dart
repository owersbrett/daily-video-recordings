enum FrequencyType {
  once,
  everyOtherDay,
  daily,
  weekly,
  biweekly,
  monthly,
  yearly,
  ;

  Map<String, dynamic> toMap() {
    return {
      'frequencyType': this.toString(),
    };
  }

  static FrequencyType fromMap(Map<String, dynamic> map) {
    return FrequencyType.values
        .firstWhere((element) => element.toString() == map['frequencyType']);
  }
}
