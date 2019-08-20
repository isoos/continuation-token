Encode and decode continuation token values for stateless pagination APIs.

Continuation data is a free-form `Map` that is:

- encoded as `JSON` String
- encoded as `UTF-8` bytes
- `XOR`-d with a given bytes of secret (optional)
- encoded as `BASE-64` String

## Usage

A simple usage example:

```dart
import 'package:continuation_token/continuation_token.dart';

main() {
  final codec = jsonMapContinuationCodec(secret: 'my-secret');

  final token = codec.encode({'id': 'abc123', 'asc': true});
  print(token); // FltEF0dZUAQWDkgfQEdPUAQHDlsXBxcWFxg

  final data = codec.decode(token);
  print(data); // {id: abc123, asc: true}
}
```
