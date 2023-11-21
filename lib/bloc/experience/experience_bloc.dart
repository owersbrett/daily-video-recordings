import 'package:mementoh/data/repositories/experience_repository.dart';
import 'package:mementoh/main.dart';

import 'experience.dart';

class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  final IExperienceRepository experienceRepository;
  ExperienceBloc(this.experienceRepository) : super(ExperienceState(const [])) {
    on<ExperienceEvent>((event, emit) async {
      log("Experience sum: " + state.sumOfAllExperience().toString());
      if (event is ExperienceAdded) {
        log(event.experience.points.toString());
        await experienceRepository.create(event.experience);
        emit(ExperienceState([...state.experience, event.experience]));
      } else if (event is ExperienceRemoved) {
        bool successfulDelete = await experienceRepository.delete(event.experience);
        log("Successful delete: $successfulDelete");
        emit(ExperienceState(await experienceRepository.getAll()));
      } else if (event is FetchExperience) {
        // experienceRepository.deleteAll();
        emit(ExperienceState(await experienceRepository.getAll()));
        log("Experience sum: " + state.sumOfAllExperience().toString());
      }
    });
  }
}
