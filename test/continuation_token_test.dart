import 'package:test/test.dart';

import 'package:continuation_token/continuation_token.dart';

void main() {
  group('valid token', () {
    test('with defaults', () {
      final token =
          continuationTokenCodec.encode({'id': 'abc123', 'asc': true});
      expect(token, 'eyJpZCI6ImFiYzEyMyIsImFzYyI6dHJ1ZX0');

      final data = continuationTokenCodec.decode(token);
      expect(data, {'id': 'abc123', 'asc': true});
    });

    test('with secret', () {
      final codec = jsonContinuationCodec(secret: 'my-secret');

      final token = codec.encode({'id': 'abc123', 'asc': true});
      expect(token, 'FltEF0dZUAQWDkgfQEdPUAQHDlsXBxcWFxg');

      final data = codec.decode(token);
      expect(data, {'id': 'abc123', 'asc': true});
    });
  });

  group('invalid token', () {
    test('with defaults', () {
      expect(() => continuationTokenCodec.decode('x'),
          throwsA(isA<FormatException>()));
    });

    test('with secret', () {
      final codec = jsonContinuationCodec(secret: 'my-secret');
      expect(() => codec.decode('x'), throwsA(isA<FormatException>()));
    });
  });

  group('String continuation', () {
    test('with defaults', () {
      final codec = stringContinuationCodec();
      expect(codec.encode('abc'), 'YWJj');
      expect(codec.decode('YWJj'), 'abc');
    });

    test('with secret', () {
      final codec = stringContinuationCodec(secret: 'my-secret');
      expect(codec.encode('abc'), 'DBtO');
      expect(codec.decode('DBtO'), 'abc');
    });

    test('invalid token with defaults', () {
      final codec = stringContinuationCodec();
      expect(() => codec.decode('x'), throwsA(isA<FormatException>()));
    });

    test('invalid token with secret', () {
      final codec = stringContinuationCodec(secret: 'my-secret');
      expect(() => codec.decode('x'), throwsA(isA<FormatException>()));
    });
  });
}
