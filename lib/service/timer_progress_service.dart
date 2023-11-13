enum TimerProgressType { sessionTime, everyTwelveHours, dayTimer, weekTimer, monthTimer, yearTimer }

class TimerProgressService {
  static double getDouble(DateTime currentTime, TimerProgressType timerType) {
    double progress = 0;
    switch (timerType) {
      case TimerProgressType.dayTimer:
        break;
      case TimerProgressType.weekTimer:
        break;
      case TimerProgressType.monthTimer:
        break;
      case TimerProgressType.yearTimer:
        break;
      case TimerProgressType.sessionTime:
        break;
      case TimerProgressType.everyTwelveHours:
        break;
    }

    return progress;
  }

  static String getString(DateTime currentTime, TimerProgressType timerType) {
    String progress = "";

    return "";
  }
}
