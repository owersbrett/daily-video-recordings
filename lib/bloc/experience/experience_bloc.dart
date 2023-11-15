import 'package:daily_video_reminders/data/repositories/experience_repository.dart';
import 'package:daily_video_reminders/main.dart';

import 'experience.dart';

class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  final IExperienceRepository experienceRepository;
  ExperienceBloc(this.experienceRepository) : super(ExperienceState(const [])) {
    on<ExperienceEvent>((event, emit) async {
      log("Experience sum: " + state.sum().toString());
      if (event is ExperienceAdded) {
        log(event.experience.points.toString());
        await experienceRepository.create(event.experience);
        emit(ExperienceState([...state.experience, event.experience]));
      } else if (event is ExperienceRemoved) {
        await experienceRepository.delete(event.experience);
        emit(ExperienceState(state.experience.where((experience) => experience.id != event.experience.id).toList()));
      } else if (event is FetchExperience) {
        // experienceRepository.deleteAll();
        emit(ExperienceState(await experienceRepository.getAll()));
        log("Experience sum: " + state.sum().toString());
      }
    });
    add(FetchExperience());
  }
}
