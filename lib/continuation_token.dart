import 'dart:convert';

import 'src/base64_codec.dart';
import 'src/cast_codec.dart';
import 'src/xor_codec.dart';

export 'src/base64_codec.dart';
export 'src/xor_codec.dart';

/// The default [Codec] that uses JSON encoding, without any secret.
final continuationTokenCodec = jsonMapContinuationCodec();

/// Creates a continuation codec that encodes the values as JSON, UTF-8, XOR
/// (if [secret] is provided) and URL-safe, no-pad BASE-64 text.
Codec<R, String> jsonContinuationCodec<R>({dynamic secret}) =>
    CastCodec<R, dynamic>()
        .fuse(json)
        .fuse(utf8)
        .fuse(XorCodec(secret))
        .fuse(base64UrlNoPad);

/// Creates a continuation codec that encodes the values as JSON Objects (Maps),
/// UTF-8, XOR (if [secret] is provided) and URL-safe, no-pad BASE-64 text.
Codec<Map<String, dynamic>, String> jsonMapContinuationCodec(
        {dynamic secret}) =>
    jsonContinuationCodec<Map<String, dynamic>>();

/// Creates a continuation codec that encodes the String value as UTF-8, XOR
/// (if [secret] is provided) and URL-safe, no-pad BASE-64 text.
Codec<String, String> stringContinuationCodec({dynamic secret}) =>
    utf8.fuse(XorCodec(secret)).fuse(base64UrlNoPad);
