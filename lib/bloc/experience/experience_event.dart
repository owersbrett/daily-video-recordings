import '../../data/experience.dart';

abstract class ExperienceEvent{}
class ExperienceAdded extends ExperienceEvent {
  final Experience experience;
  ExperienceAdded(this.experience);
}
class ExperienceRemoved extends ExperienceEvent {
  final Experience experience;
  ExperienceRemoved(this.experience);
}
class FetchExperience extends ExperienceEvent {
}