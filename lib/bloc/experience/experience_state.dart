import 'package:habitbit/main.dart';
import 'package:habitbit/service/admin_service.dart';
import 'package:equatable/equatable.dart';

import '../../data/experience.dart';
import '../../data/level.dart';

class ExperienceState extends Equatable {
  final List<Experience> experience;
  final List<Level> levels = AdminService.get100Levels();
  ExperienceState(this.experience);

  @override
  List<Object?> get props => [experience.length];

  int sumOfAllExperience() => experience.fold(0, (previousValue, element) => previousValue + element.points);

  int todays() => experience.fold(0, (previousValue, element) {
        var now = DateTime.now();
        var startInterval = DateTime(now.year, now.month, now.day);
        var endInterval = DateTime(now.year, now.month, now.day + 1);
        if (element.createdAt.isAfter(startInterval) && element.createdAt.isBefore(endInterval)) {
          return previousValue + element.points;
        } else {
          return previousValue;
        }
      });
  int thisMonths() => experience.fold(0, (previousValue, element) {
        var now = DateTime.now();
        var startInterval = DateTime(now.year, now.month);
        var endInterval = DateTime(now.year, now.month + 1);
        if (element.createdAt.isAfter(startInterval) && element.createdAt.isBefore(endInterval)) {
          return previousValue + element.points;
        } else {
          return previousValue;
        }
      });
  int thisWeeks() => experience.fold(0, (previousValue, element) {
        var now = DateTime.now();
        var startInterval = DateTime(now.year, now.month, now.day - now.weekday);
        var endInterval = DateTime(now.year, now.month, now.day + (7 - now.weekday));
        if (element.createdAt.isAfter(startInterval) && element.createdAt.isBefore(endInterval)) {
          return previousValue + element.points;
        } else {
          return previousValue;
        }
      });

  String getCurrentLevel() {
    int level = 0;
    int points = sumOfAllExperience();
    for (var i = 0; i < levels.length; i++) {
      if (points >= levels[i].pointsToUnlock) {
        level = levels[i].id;
      } else {
        return 1.toString();
      }
    }
    return level.toString();
  }

  int currentLevelsPointsToUnlock() {
    int points = sumOfAllExperience();
    for (var i = 0; i < levels.length; i++) {
      if (points < levels[i].pointsToUnlock) {
        return levels[i].pointsToUnlock;
      }
    }
    return 0;
  }

  int experienceUntilNextLevel() {
    int exp = 0;
    int points = sumOfAllExperience();
    for (var i = 0; i < levels.length; i++) {
      if (points < levels[i].pointsToUnlock) {
        exp = levels[i].pointsToUnlock - points;
        break;
      }
    }
    return exp;
  }

  double percentageToNextLevel() {
    int allExp = sumOfAllExperience();
    int _currentLevel = currentLevel();
    int sumOfLevelsToLevel = sumOfLevelToLevel(_currentLevel);
    if (allExp + currentLevelsPointsToUnlock() == sumOfLevelsToLevel) {
      return 0;
    }
    int numerator = (allExp - sumOfLevelToLevel(_currentLevel - 1));
    int denominator = sumOfLevelsToLevel - sumOfLevelToLevel(_currentLevel - 1);
    double percentage = numerator / denominator;
    return percentage;
  }

  int currentLevel() {
    int level = 0;
    int points = sumOfAllExperience();
    int pointCounter = 0;
    for (var i = 0; i < levels.length; i++) {
      pointCounter += levels[i].pointsToUnlock;
      if (points < pointCounter) {
        level = levels[i].id;
        break;
      }
    }
    return level;
  }

  int sumOfLevelToLevel(int level) {
    int sum = 0;
    for (var i = 0; i < levels.length; i++) {
      if (levels[i].id <= level) {
        sum += levels[i].pointsToUnlock;
      }
    }
    return sum;
  }

  int sumOfPreviousLevelsExperience() {
    int sum = 0;
    int points = sumOfAllExperience();
    if (currentLevelsPointsToUnlock() == 100) return 0;
    for (var i = 0; i < levels.length; i++) {
      if (points < levels[i].pointsToUnlock) {
        sum = levels[i - 1].pointsToUnlock;
        break;
      }
    }
    return sum;
  }
}

class ExperienceLoaded extends ExperienceState {
  ExperienceLoaded(super.experience);
}
