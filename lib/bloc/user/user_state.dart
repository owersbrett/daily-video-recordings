import 'package:daily_video_reminders/data/user_entity.dart';

import '../../data/user.dart';

abstract class UserState {
  UserEntity get userEntity => UserEntity(
        user: User(
          id: 1,
          name: 'You',
          createDate: DateTime.now(),
          updateDate: DateTime.now(),
        ),
        habits: [],
        multimedia: [],
      );
}

class UserInitial extends UserState {}
