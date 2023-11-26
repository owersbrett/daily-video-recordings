import 'package:intl/intl.dart';
import 'package:mementohr/main.dart';

class NowData {
  DateTime startTime;
  Duration elapsedTime;
  DateTime currentTime;
  DateTime? startTimerTimer;

  NowData()
      : startTime = DateTime.now(),
        elapsedTime = Duration.zero,
        currentTime = DateTime.now();

  double get elapsedFractionOfHour {
    elapsedTime = DateTime.now().difference(startTime);
    double fraction = elapsedTime.inMinutes / 60;
    if (fraction >= 1.0) {
      timeLimitReached();
      fraction = 1.0; // To ensure it doesn't exceed 1.0
    }
    return fraction;
  }

  double get dayOfYear => DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays + 1;
  int get totalDays => DateTime(DateTime.now().year, 12, 31).difference(DateTime(DateTime.now().year, 1, 1)).inDays + 1;
  double get dayOfYearFraction => dayOfYear / totalDays;

  String formattedMonth(DateTime from) => DateFormat('EEEE MMMM d').format(from);

  void timeLimitReached() {
    log("Time limit reached!");
  }

  String get formattedDate {
    return DateFormat('D').format(currentTime);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    } else if (duration.inMinutes > 0) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return ":$twoDigitSeconds";
    }
  }

  String getWeekAndSeason(DateTime currentDate) {
    // Define the start dates of each season
    DateTime winterStart = DateTime(currentDate.year, 12, 21);
    DateTime springStart = DateTime(currentDate.year, 3, 21);
    DateTime summerStart = DateTime(currentDate.year, 6, 21);
    DateTime autumnStart = DateTime(currentDate.year, 9, 21);

    String season;
    DateTime seasonStart;

    // Determine the current season and its start date
    if (currentDate.isAfter(autumnStart) || currentDate.isAtSameMomentAs(autumnStart)) {
      season = "Autumn";
      seasonStart = autumnStart;
    } else if (currentDate.isAfter(summerStart) || currentDate.isAtSameMomentAs(summerStart)) {
      season = "Summer";
      seasonStart = summerStart;
    } else if (currentDate.isAfter(springStart) || currentDate.isAtSameMomentAs(springStart)) {
      season = "Spring";
      seasonStart = springStart;
    } else {
      season = "Winter";
      seasonStart = currentDate.year == winterStart.year ? winterStart : DateTime(currentDate.year - 1, 12, 21);
    }

    // Calculate the week number within the season
    int weekNumber = ((currentDate.difference(seasonStart).inDays) / 7).ceil();

    return "Week $weekNumber of $season";
  }
}
