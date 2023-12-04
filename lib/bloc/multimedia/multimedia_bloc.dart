import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habitbit/data/multimedia_file.dart';
import 'package:habitbit/data/repositories/multimedia_repository.dart';
import 'package:habitbit/main.dart';
import 'package:habitbit/service/media_service.dart';
import 'package:uuid/uuid.dart';

import 'multimedia.dart';

class MultimediaBloc extends Bloc<MultimediaEvent, MultimediaState> {
  final IMultimediaRepository multimediaRepository;
  MultimediaBloc(this.multimediaRepository) : super(MultimediaLoaded([])) {
    on<MultimediaEvent>((event, emit) => _onEvent(event, emit));
    add(FetchMultimedia());
  }

  Future _onEvent(MultimediaEvent event, Emitter<MultimediaState> emit) async {
    if (event is FetchMultimedia) await _fetchMultimedia(event, emit);
    if (event is DeleteMultimedia) await _deleteMultimedia(event, emit);
    if (event is AddMultimedia) await _addMultimedia(event, emit);
  }

  Future _addMultimedia(AddMultimedia event, Emitter<MultimediaState> emit) async {
    MultimediaFile multimediaFile = await MediaService.saveVideoClipsToOneFile(event.clips, const Uuid().v4());
    if (multimediaFile.videoFile == null) {
      ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(content: Text("Video file is null")));
      throw Exception("Video file is null");
    } else {
      File file = multimediaFile.videoFile!;
      Navigator.of(event.context).popUntil((route) => route.isFirst);
      log(file.path);
      add(FetchMultimedia());
    }
  }

  Future _deleteMultimedia(DeleteMultimedia event, Emitter<MultimediaState> emit) async {
    await File(event.filePath).delete();
    add(FetchMultimedia());
  }

  Future _fetchMultimedia(FetchMultimedia event, Emitter<MultimediaState> emit) async {
    List<MultimediaFile> multimediaList = await MediaService.retrieveMultimediaFiles();
    for (var element in multimediaList) {
      if (element.photoFile == null) {
        await MediaService.setThumbnail(element.videoFile!);
      }
    }
    multimediaList = await MediaService.retrieveMultimediaFiles();
    emit(MultimediaLoaded(multimediaList));
  }
}
