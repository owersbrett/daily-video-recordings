import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:habit_planet/data/experience.dart';
import 'package:habit_planet/data/repositories/experience_repository.dart';
import 'package:habit_planet/data/repositories/user_repository.dart';
import 'package:habit_planet/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/habit_entry_repository.dart';
import '../../data/repositories/habit_repository.dart';
import '../../data/user.dart';
import 'user.dart';

class UserBloc extends HydratedBloc<UserEvent, UserState> {
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
    if (event is SplashPageClosed) await _splashPageClosed(event, emit);
    if (event is SplashPageRequested) await _splashPageRequested(event, emit);
  }

  Future _splashPageRequested(SplashPageRequested event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      List<Experience> experienceList = await experienceRepository.getAll();

      emit(UserLoaded(state.user, experienceList, false));
    }
  }

  Future _splashPageClosed(SplashPageClosed event, Emitter<UserState> emit) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("hasSeenSplashPage", true);
    List<Experience> experienceList = await experienceRepository.getAll();

    emit(UserLoaded(state.user, experienceList, true));
  }

  Future _fetchUser(FetchUser event, Emitter<UserState> emit) async {
    try {
      User user = await userRepository.get();
      List<Experience> experienceList = await experienceRepository.getAll();
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      bool hasSeenSharedPreferences = sharedPreferences.getBool("hasSeenSplashPage") ?? false;
      emit(UserLoaded(user, experienceList, hasSeenSharedPreferences));
    } catch (e) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      bool hasSeenSharedPreferences = sharedPreferences.getBool("hasSeenSplashPage") ?? false;
      log(e.toString());
      log("404 User Not Found.");
      log("Creating user.");
      User user = User(name: 'You', createDate: DateTime.now(), updateDate: DateTime.now());
      user = await userRepository.create(user);
      log("200 User Created.");
      List<Experience> experienceList = await experienceRepository.getAll();
      emit(UserLoaded(user, experienceList, hasSeenSharedPreferences));
    }
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) {
    return UserLoaded(User.fromMap(json), const [], json["hasSeenSplashPage"]);
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    Map<String, dynamic> map = state.user.toMap();
    map["hasSeenSplashPage"] = state.hasSeenSplashPage;
    return null;
  }
}
