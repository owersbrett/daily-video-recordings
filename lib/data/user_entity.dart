import 'package:mementoh/data/habit_entity.dart';
import 'package:mementoh/data/multimedia.dart';

import 'user.dart';

class UserEntity {
  final User user;
  final List<HabitEntity> habits;
  final List<Multimedia> multimedia;

  UserEntity({required this.user, required this.habits, required this.multimedia});
}
