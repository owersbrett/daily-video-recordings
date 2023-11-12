//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'service.pb.dart' as $0;

export 'service.pb.dart';

@$pb.GrpcServiceName('dailyvideoreminders.AudioSplitter')
class AudioSplitterClient extends $grpc.Client {
  static final _$splitAudio = $grpc.ClientMethod<$0.SplitAudioRequest, $0.SplitAudioResponse>(
      '/dailyvideoreminders.AudioSplitter/SplitAudio',
      ($0.SplitAudioRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SplitAudioResponse.fromBuffer(value));

  AudioSplitterClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.SplitAudioResponse> splitAudio($0.SplitAudioRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$splitAudio, request, options: options);
  }
}

@$pb.GrpcServiceName('dailyvideoreminders.AudioSplitter')
abstract class AudioSplitterServiceBase extends $grpc.Service {
  $core.String get $name => 'dailyvideoreminders.AudioSplitter';

  AudioSplitterServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SplitAudioRequest, $0.SplitAudioResponse>(
        'SplitAudio',
        splitAudio_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SplitAudioRequest.fromBuffer(value),
        ($0.SplitAudioResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SplitAudioResponse> splitAudio_Pre($grpc.ServiceCall call, $async.Future<$0.SplitAudioRequest> request) async {
    return splitAudio(call, await request);
  }

  $async.Future<$0.SplitAudioResponse> splitAudio($grpc.ServiceCall call, $0.SplitAudioRequest request);
}
