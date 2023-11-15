import 'package:daily_video_reminders/data/repositories/multimedia_repository.dart';

import 'multimedia.dart';

class MultimediaBloc extends Bloc<MultimediaEvent, MultimediaState> {
  final IMultimediaRepository multimediaRepository;
  MultimediaBloc(this.multimediaRepository) : super(MultimediaLoaded()) {
    on<MultimediaEvent>((event, emit) {});
  }
}
