//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// The request message containing all the parameters needed for audio splitting.
class SplitAudioRequest extends $pb.GeneratedMessage {
  factory SplitAudioRequest({
    $core.String? filePath,
    $core.int? silenceThreshold,
    $core.int? minSilenceLength,
  }) {
    final $result = create();
    if (filePath != null) {
      $result.filePath = filePath;
    }
    if (silenceThreshold != null) {
      $result.silenceThreshold = silenceThreshold;
    }
    if (minSilenceLength != null) {
      $result.minSilenceLength = minSilenceLength;
    }
    return $result;
  }
  SplitAudioRequest._() : super();
  factory SplitAudioRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplitAudioRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplitAudioRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'dailyvideoreminders'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'filePath')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'silenceThreshold', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'minSilenceLength', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplitAudioRequest clone() => SplitAudioRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplitAudioRequest copyWith(void Function(SplitAudioRequest) updates) => super.copyWith((message) => updates(message as SplitAudioRequest)) as SplitAudioRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SplitAudioRequest create() => SplitAudioRequest._();
  SplitAudioRequest createEmptyInstance() => create();
  static $pb.PbList<SplitAudioRequest> createRepeated() => $pb.PbList<SplitAudioRequest>();
  @$core.pragma('dart2js:noInline')
  static SplitAudioRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SplitAudioRequest>(create);
  static SplitAudioRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get filePath => $_getSZ(0);
  @$pb.TagNumber(1)
  set filePath($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFilePath() => $_has(0);
  @$pb.TagNumber(1)
  void clearFilePath() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get silenceThreshold => $_getIZ(1);
  @$pb.TagNumber(2)
  set silenceThreshold($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSilenceThreshold() => $_has(1);
  @$pb.TagNumber(2)
  void clearSilenceThreshold() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get minSilenceLength => $_getIZ(2);
  @$pb.TagNumber(3)
  set minSilenceLength($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMinSilenceLength() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinSilenceLength() => clearField(3);
}

/// The response message containing the result of the audio splitting.
class SplitAudioResponse extends $pb.GeneratedMessage {
  factory SplitAudioResponse({
    $core.Iterable<$core.String>? segmentPaths,
  }) {
    final $result = create();
    if (segmentPaths != null) {
      $result.segmentPaths.addAll(segmentPaths);
    }
    return $result;
  }
  SplitAudioResponse._() : super();
  factory SplitAudioResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplitAudioResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplitAudioResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'dailyvideoreminders'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'segmentPaths')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplitAudioResponse clone() => SplitAudioResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplitAudioResponse copyWith(void Function(SplitAudioResponse) updates) => super.copyWith((message) => updates(message as SplitAudioResponse)) as SplitAudioResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SplitAudioResponse create() => SplitAudioResponse._();
  SplitAudioResponse createEmptyInstance() => create();
  static $pb.PbList<SplitAudioResponse> createRepeated() => $pb.PbList<SplitAudioResponse>();
  @$core.pragma('dart2js:noInline')
  static SplitAudioResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SplitAudioResponse>(create);
  static SplitAudioResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get segmentPaths => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
