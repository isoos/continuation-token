import 'dart:convert';
import 'dart:typed_data';

/// The default [ContinuationTokenCodec] without and secret.
final continuationTokenCodec = ContinuationTokenCodec();

/// Codec to handle continuation encoding and decoding.
///
/// Continuation data is a free-form [Map] that is:
/// - encoded as JSON String
/// - encoded as UTF-8 bytes
/// - XOR-d with a given bytes of secret (optional)
/// - encoded as BASE-64 String
///
/// Decoding throws [FormatException] when the input String cannot be parsed.
class ContinuationTokenCodec extends Codec<Map<String, dynamic>, String> {
  final Converter<String, Map<String, dynamic>> _decoder;
  final Converter<Map<String, dynamic>, String> _encoder;
  ContinuationTokenCodec({dynamic secret})
      : _decoder = ContinuationTokenDecoder(secret: secret),
        _encoder = ContinuationTokenEncoder(secret: secret);

  @override
  Converter<String, Map<String, dynamic>> get decoder => _decoder;

  @override
  Converter<Map<String, dynamic>, String> get encoder => _encoder;
}

/// Encodes continuation token.
///
/// Continuation data is a free-form [Map] that is:
/// - encoded as JSON String
/// - encoded as UTF-8 bytes
/// - XOR-d with a given bytes of secret (optional)
/// - encoded as BASE-64 String
class ContinuationTokenEncoder extends Converter<Map<String, dynamic>, String> {
  final Uint8List _secret;
  ContinuationTokenEncoder({dynamic secret}) : _secret = _convertSecret(secret);

  @override
  String convert(Map<String, dynamic> input) {
    if (input == null) return null;
    final bytes = Uint8List.fromList(utf8.encode(json.encode(input)));
    if (_secret != null && _secret.isNotEmpty) {
      for (int i = 0; i < bytes.length; i++) {
        bytes[i] = bytes[i] ^ _secret[i % _secret.length];
      }
    }
    return _trimPadding(base64Url.encode(bytes));
  }

  String _trimPadding(String text) {
    if (text.endsWith('==')) {
      return text.substring(0, text.length - 2);
    } else if (text.endsWith('=')) {
      return text.substring(0, text.length - 1);
    } else {
      return text;
    }
  }
}

/// Decodes continuation token.
///
/// Continuation data is a free-form [Map] that is:
/// - encoded as JSON String
/// - encoded as UTF-8 bytes
/// - XOR-d with a given bytes of secret (optional)
/// - encoded as BASE-64 String
///
/// Throws [FormatException] when the input String cannot be parsed.
class ContinuationTokenDecoder extends Converter<String, Map<String, dynamic>> {
  final Uint8List _secret;
  ContinuationTokenDecoder({dynamic secret}) : _secret = _convertSecret(secret);

  @override
  Map<String, dynamic> convert(String input) {
    if (input == null) return null;
    try {
      final bytes = Uint8List.fromList(base64Url.decode(_addPadding(input)));
      if (_secret != null && _secret.isNotEmpty) {
        for (int i = 0; i < bytes.length; i++) {
          bytes[i] = bytes[i] ^ _secret[i % _secret.length];
        }
      }
      return json.decode(utf8.decode(bytes)) as Map<String, dynamic>;
    } catch (_) {
      throw FormatException('Token parse failed.');
    }
  }

  String _addPadding(String text) {
    final length = text.length;
    if (length % 4 == 0) return text;
    final fullLength = ((length >> 2) + 1) << 2;
    final padding = '=' * (fullLength - length);
    return '$text$padding';
  }
}

Uint8List _convertSecret(secret) {
  if (secret == null) {
    return null;
  } else if (secret is String) {
    return Uint8List.fromList(utf8.encode(secret));
  } else if (secret is Uint8List) {
    return secret;
  } else if (secret is List<int>) {
    return Uint8List.fromList(secret);
  } else {
    throw ArgumentError('Unknown secret type: ${secret.runtimeType}');
  }
}
