import 'dart:convert';
import 'dart:typed_data';

/// Allows light protection of bytes by XOR-ing them with another byte array (secret).
///
/// When no secret is specified, the codec is just a pass-through (identity codec).
class XorCodec extends Codec<List<int>, List<int>> {
  final _XorConverter _converter;

  XorCodec(dynamic secret) : _converter = _XorConverter(secret);

  @override
  Converter<List<int>, List<int>> get decoder => _converter;

  @override
  Converter<List<int>, List<int>> get encoder => _converter;
}

class _XorConverter extends Converter<List<int>, List<int>> {
  final Uint8List _secretBytes;

  _XorConverter._(this._secretBytes);
  factory _XorConverter(dynamic secret) => _XorConverter._(_castSecret(secret));

  @override
  List<int> convert(List<int> input) {
    if (_secretBytes == null || _secretBytes.isEmpty) {
      return input;
    } else {
      final bytes = Uint8List.fromList(input);
      for (int i = 0; i < bytes.length; i++) {
        bytes[i] = bytes[i] ^ _secretBytes[i % _secretBytes.length];
      }
      return bytes;
    }
  }
}

Uint8List _castSecret(secret) {
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
