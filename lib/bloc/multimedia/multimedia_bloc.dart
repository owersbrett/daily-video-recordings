import 'package:daily_video_reminders/data/multimedia_file.dart';
import 'package:daily_video_reminders/data/repositories/multimedia_repository.dart';
import 'package:daily_video_reminders/service/media_service.dart';

import '../../data/multimedia.dart';
import 'multimedia.dart';

class MultimediaBloc extends Bloc<MultimediaEvent, MultimediaState> {
  final IMultimediaRepository multimediaRepository;
  MultimediaBloc(this.multimediaRepository) : super(MultimediaLoaded([])) {
    on<MultimediaEvent>((event, emit) => _onEvent(event, emit));
    add(FetchMultimedia());
  }

  Future _onEvent(MultimediaEvent event, Emitter<MultimediaState> emit) async {
    if (event is FetchMultimedia) await _fetchMultimedia(event, emit);
  }

  Future _fetchMultimedia(FetchMultimedia event, Emitter<MultimediaState> emit) async {
    List<MultimediaFile> multimediaList = await MediaService.retrieveMultimediaFiles();
    emit(MultimediaLoaded(multimediaList));
  }
}
