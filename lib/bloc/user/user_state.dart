import 'package:habitbit/data/experience.dart';
import 'package:equatable/equatable.dart';

import '../../data/user.dart';

abstract class UserState extends Equatable {
  User get user;
  bool get hasSeenSplashPage;
  List<Experience> get experience;
  @override
  List<Object?> get props => [hasSeenSplashPage, user, ...experience];
}

class UserInitial extends UserState {
  @override
  User get user => User(createDate: DateTime.now(), updateDate: DateTime.now(), name: "You");

  @override
  List<Experience> get experience => [];

  @override
  bool get hasSeenSplashPage => true;
}

class UserLoaded extends UserState {
  @override
  final User user;
  @override
  final bool hasSeenSplashPage;
  UserLoaded(this.user, this.experience, this.hasSeenSplashPage);

  @override
  final List<Experience> experience;
}
