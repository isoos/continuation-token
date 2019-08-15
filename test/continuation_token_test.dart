import 'package:test/test.dart';

import 'package:continuation_token/continuation_token.dart';

void main() {
  group('valid token', () {
    test('with defaults', () {
      final codec = ContinuationTokenCodec();

      final token = codec.encode({'id': 'abc123', 'asc': true});
      expect(token, 'eyJpZCI6ImFiYzEyMyIsImFzYyI6dHJ1ZX0=');

      final data = codec.decode(token);
      expect(data, {'id': 'abc123', 'asc': true});
    });

    test('with secret', () {
      final codec = ContinuationTokenCodec(secret: 'my-secret');

      final token = codec.encode({'id': 'abc123', 'asc': true});
      expect(token, 'FltEF0dZUAQWDkgfQEdPUAQHDlsXBxcWFxg=');

      final data = codec.decode(token);
      expect(data, {'id': 'abc123', 'asc': true});
    });
  });

  group('invalid token', () {
    test('with defaults', () {
      final codec = ContinuationTokenCodec();
      expect(() => codec.decode('x'), throwsA(isA<FormatException>()));
    });

    test('with secret', () {
      final codec = ContinuationTokenCodec(secret: 'my-secret');
      expect(() => codec.decode('x'), throwsA(isA<FormatException>()));
    });
  });
}
