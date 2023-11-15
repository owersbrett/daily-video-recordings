class KeyUtil {
  static String getDailyKeyFromDateTime(DateTime dateTime){
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }
  static DateTime getDateTimeFromDailyKey(String dailyKey){
    List<String> dateParts = dailyKey.split("-");
    return DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
  }

}