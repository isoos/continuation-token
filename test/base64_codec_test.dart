import 'dart:math';

import 'package:continuation_token/src/base64_codec.dart';

import 'package:test/test.dart';

void main() {
  test('Encode and decode random values', () {
    final random = Random.secure();
    for (var i = 0; i < 10000; i++) {
      final input = List<int>.generate(
          100 + random.nextInt(100), (i) => random.nextInt(256));
      final encoded = base64UrlNoPad.encode(input);
      final decoded = base64UrlNoPad.decode(encoded);
      expect(decoded, input);
    }
  });

  test('Padding removal', () async {
    expect(base64UrlNoPad.encode([]), '');
    expect(base64UrlNoPad.encode([1]), 'AQ');
    expect(base64UrlNoPad.encode([1, 2]), 'AQI');
    expect(base64UrlNoPad.encode([1, 2, 3]), 'AQID');
    expect(base64UrlNoPad.encode([1, 2, 3, 4]), 'AQIDBA');
    expect(base64UrlNoPad.encode([1, 2, 3, 4, 5]), 'AQIDBAU');
  });
}
