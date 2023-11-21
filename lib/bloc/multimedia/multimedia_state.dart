import 'package:mementoh/data/multimedia_file.dart';
import 'package:equatable/equatable.dart';


abstract class MultimediaState implements Equatable {
  List<MultimediaFile> get multimediaList;
}

class MultimediaLoaded extends MultimediaState {
  @override
  final List<MultimediaFile> multimediaList;
  MultimediaLoaded(this.multimediaList);
  @override
  List<Object?> get props => [...multimediaList];

  @override
  bool? get stringify => throw UnimplementedError();
}
