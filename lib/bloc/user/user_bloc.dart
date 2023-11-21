import 'package:mementoh/data/experience.dart';
import 'package:mementoh/data/repositories/experience_repository.dart';
import 'package:mementoh/data/repositories/user_repository.dart';
import 'package:mementoh/main.dart';

import '../../data/repositories/habit_entry_repository.dart';
import '../../data/repositories/habit_repository.dart';
import '../../data/user.dart';
import 'user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final IUserRepository userRepository;
  final IHabitRepository habitRepository;
  final IHabitEntryRepository habitEntryRepository;
  final IExperienceRepository experienceRepository;
  UserBloc(
    this.userRepository,
    this.habitRepository,
    this.habitEntryRepository,
    this.experienceRepository,
  ) : super(UserInitial()) {
    on<UserEvent>(_onEvent);
  }

  Future _onEvent(UserEvent event, Emitter<UserState> emit) async {
    if (event is FetchUser) await _fetchUser(event, emit);
  }

  Future _fetchUser(FetchUser event, Emitter<UserState> emit) async {
    try {

      User user = await userRepository.get();
      List<Experience> experienceList = await experienceRepository.getAll();
      emit(UserLoaded(user, experienceList));
    } catch (e) {
      log(e.toString());
      log("404 User Not Found.");
      log("Creating user.");
      User user = User(name: 'You', createDate: DateTime.now(), updateDate: DateTime.now());
      user = await userRepository.create(user);
      log("200 User Created.");
      List<Experience> experienceList = await experienceRepository.getAll();
      emit(UserLoaded(user, experienceList));
    }
  }
}
