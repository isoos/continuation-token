import 'dart:convert';

class CastCodec<S, T> extends Codec<S, T> {
  @override
  final Converter<T, S> decoder = _CastConverter<T, S>();

  @override
  final Converter<S, T> encoder = _CastConverter<S, T>();
}

class _CastConverter<S, T> extends Converter<S, T> {
  @override
  T convert(S input) {
    return input as T;
  }
}
