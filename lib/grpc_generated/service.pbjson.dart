//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use splitAudioRequestDescriptor instead')
const SplitAudioRequest$json = {
  '1': 'SplitAudioRequest',
  '2': [
    {'1': 'file_path', '3': 1, '4': 1, '5': 9, '10': 'filePath'},
    {'1': 'silence_threshold', '3': 2, '4': 1, '5': 5, '10': 'silenceThreshold'},
    {'1': 'min_silence_length', '3': 3, '4': 1, '5': 5, '10': 'minSilenceLength'},
  ],
};

/// Descriptor for `SplitAudioRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List splitAudioRequestDescriptor = $convert.base64Decode(
    'ChFTcGxpdEF1ZGlvUmVxdWVzdBIbCglmaWxlX3BhdGgYASABKAlSCGZpbGVQYXRoEisKEXNpbG'
    'VuY2VfdGhyZXNob2xkGAIgASgFUhBzaWxlbmNlVGhyZXNob2xkEiwKEm1pbl9zaWxlbmNlX2xl'
    'bmd0aBgDIAEoBVIQbWluU2lsZW5jZUxlbmd0aA==');

@$core.Deprecated('Use splitAudioResponseDescriptor instead')
const SplitAudioResponse$json = {
  '1': 'SplitAudioResponse',
  '2': [
    {'1': 'segment_paths', '3': 1, '4': 3, '5': 9, '10': 'segmentPaths'},
  ],
};

/// Descriptor for `SplitAudioResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List splitAudioResponseDescriptor = $convert.base64Decode(
    'ChJTcGxpdEF1ZGlvUmVzcG9uc2USIwoNc2VnbWVudF9wYXRocxgBIAMoCVIMc2VnbWVudFBhdG'
    'hz');

