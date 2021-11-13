## 2.1.0

- Migrated to null safety.

## 2.0.0

** BREAKING CHANGES **

- `ContinuationTokenCodec` class removed, use `jsonMapContinuationCodec()`
  method instead.

New features:

- `stringContinuationCodec()` to encode simple Strings.
- exposing `base64UrlNoPad` and `XorCodec` separately.

## 1.0.1

- URL-safe base64-encoding, without the extra padding.

## 1.0.0

- Initial version.
