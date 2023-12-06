import 'package:habit_planet/data/habit_entity.dart';
import 'package:habit_planet/data/multimedia.dart';

import 'user.dart';

class UserEntity {
  final User user;
  final List<HabitEntity> habits;
  final List<Multimedia> multimedia;

  UserEntity({required this.user, required this.habits, required this.multimedia});
}
