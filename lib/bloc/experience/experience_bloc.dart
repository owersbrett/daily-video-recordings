import 'package:mementohr/data/repositories/experience_repository.dart';
import 'package:mementohr/main.dart';

import 'experience.dart';

class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  final IExperienceRepository experienceRepository;
  ExperienceBloc(this.experienceRepository) : super(ExperienceState(const [])) {
    on<ExperienceEvent>((event, emit) async {
      if (event is ExperienceAdded) {
        await experienceRepository.create(event.experience);
        emit(ExperienceState([...state.experience, event.experience]));
      } else if (event is ExperienceRemoved) {
        await experienceRepository.delete(event.experience);
        emit(ExperienceState(await experienceRepository.getAll()));
      } else if (event is FetchExperience) {
        emit(ExperienceState(await experienceRepository.getAll()));
      }
    });
  }
}
