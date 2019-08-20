import 'dart:convert';

class CastCodec<S, T> extends Codec<S, T> {
  @override
  final decoder = _CastConverter<T, S>();

  @override
  final encoder = _CastConverter<S, T>();
}

class _CastConverter<S, T> extends Converter<S, T> {
  @override
  T convert(S input) {
    return input as T;
  }
}
