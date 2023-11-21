import 'package:mementoh/data/experience.dart';
import 'package:equatable/equatable.dart';

import '../../data/user.dart';

abstract class UserState extends Equatable {
  User get user;
  List<Experience> get experience;
  @override
  List<Object?> get props => [user];
}

class UserInitial extends UserState {
  @override
  User get user => User(createDate: DateTime.now(), updateDate: DateTime.now(), name: "You");

  @override
  List<Experience> get experience => [];
}

class UserLoaded extends UserState {
  @override
  final User user;

  UserLoaded(this.user, this.experience);

  @override
  final List<Experience> experience;
}
