import 'dart:math';

import 'package:continuation_token/src/xor_codec.dart';

import 'package:test/test.dart';

void main() {
  test('Encode and decode random values', () {
    final random = Random.secure();
    for (var j = 0; j < 10; j++) {
      final codec = XorCodec(List<int>.generate(
          10 + random.nextInt(10), (i) => random.nextInt(256)));
      for (var i = 0; i < 1000; i++) {
        final input = List<int>.generate(
            100 + random.nextInt(100), (i) => random.nextInt(256));
        final encoded = codec.encode(input);
        final decoded = codec.decode(encoded);
        expect(decoded, input);
      }
    }
  });

  test('Simple test with identity-like secret', () {
    final codec = XorCodec('abc');
    expect(codec.encode('abc'.codeUnits), [0, 0, 0]);
    expect(codec.encode('abca'.codeUnits), [0, 0, 0, 0]);
    expect(codec.encode('abcabc'.codeUnits), [0, 0, 0, 0, 0, 0]);
    expect(codec.decode([0, 0, 0, 0]), 'abca'.codeUnits);
  });

  test('Value test', () {
    final codec = XorCodec([13]);
    expect(codec.encode([31]), [18]);
    expect(codec.encode([30]), [19]);
  });
}
