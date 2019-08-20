import 'dart:convert';

/// Allows base64 encoding bytes into ASCII strings and decoding valid encodings
/// back to bytes. This is a modified version of [Base64Codec] in `dart:convert`,
/// using no URL-safe characters ([base64Url]) with no padding (the `=`
/// characters at the end).
final base64UrlNoPad = base64Url.fuse(_NoPadCodec());

class _NoPadCodec extends Codec<String, String> {
  @override
  final encoder = _NoPadEncoder();

  @override
  final decoder = _NoPadDecoder();
}

class _NoPadEncoder extends Converter<String, String> {
  @override
  String convert(String input) {
    if (input.endsWith('==')) {
      return input.substring(0, input.length - 2);
    } else if (input.endsWith('=')) {
      return input.substring(0, input.length - 1);
    } else {
      return input;
    }
  }
}

class _NoPadDecoder extends Converter<String, String> {
  @override
  String convert(String input) {
    final length = input.length;
    if (length % 4 == 0) return input;
    final fullLength = ((length >> 2) + 1) << 2;
    final padding = '=' * (fullLength - length);
    return '$input$padding';
  }
}
