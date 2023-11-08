enum UnitType {
  fluidOunce,
  actions,
  time,
  words,
  prep,
  learn,
  distance,
  minutes,
  weight,
  reps,
  sets,
  blank,
  pages,
  other;
  
  Map<String, dynamic> toMap(){
    return {
      'unitType': this.toString(),
    };
  }
  static UnitType fromMap(Map<String, dynamic> map){
    return UnitType.values.firstWhere((element) => element.toString() == map['unitType']);
  }
}
