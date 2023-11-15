import 'package:equatable/equatable.dart';

import '../../data/experience.dart';

class ExperienceState extends Equatable {
  final List<Experience> experience;
  ExperienceState(this.experience);

  @override
  List<Object?> get props => [experience.length];

  int sum() => experience.fold(0, (previousValue, element) => previousValue + element.points);

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

  
}

class ExperienceLoaded extends ExperienceState {
  ExperienceLoaded(super.experience);
}