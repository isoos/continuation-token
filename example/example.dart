import 'package:continuation_token/continuation_token.dart';

main() {
  final codec = jsonMapContinuationCodec(secret: 'my-secret');

  final token = codec.encode({'id': 'abc123', 'asc': true});
  print(token); // FltEF0dZUAQWDkgfQEdPUAQHDlsXBxcWFxg

  final data = codec.decode(token);
  print(data); // {id: abc123, asc: true}
}
