import 'package:equatable/equatable.dart';

abstract class MultimediaState implements Equatable{}

class MultimediaLoaded extends MultimediaState {
  @override
  List<Object> get props => [];
  
  @override
  bool? get stringify => throw UnimplementedError();
}