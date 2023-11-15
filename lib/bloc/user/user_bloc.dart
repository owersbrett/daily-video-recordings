import 'package:daily_video_reminders/data/habit_entity.dart';
import 'package:daily_video_reminders/data/repositories/user_repository.dart';
import 'package:daily_video_reminders/main.dart';

import '../../data/habit.dart';
import '../../data/habit_entry.dart';
import '../../data/repositories/habit_entry_repository.dart';
import '../../data/repositories/habit_repository.dart';
import '../../data/user.dart';
import 'user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final IUserRepository userRepository;
  final IHabitRepository habitRepository;
  final IHabitEntryRepository habitEntryRepository;
  UserBloc(
    this.userRepository,
    this.habitRepository,
    this.habitEntryRepository,
  ) : super(UserInitial()) {
    on<UserEvent>(_onEvent);
  }

  Future _onEvent(UserEvent event, Emitter<UserState> emit) async {
    if (event is FetchUser) await _fetchUser(event, emit);
  }

  Future _fetchUser(FetchUser event, Emitter<UserState> emit) async {
    try {
      log("Fetching user...");
      User user = await userRepository.get();
      emit(UserLoaded(user));
    } catch (e) {
      log(e.toString());
      log("404 User Not Found.");
      log("Creating user.");
      User user = User(name: 'You', createDate: DateTime.now(), updateDate: DateTime.now());
      user = await userRepository.create(user);
      log("200 User Created.");
      emit(UserLoaded(user));
    }
  }
}
