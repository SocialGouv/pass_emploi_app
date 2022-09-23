import 'dart:convert';
import 'dart:typed_data';

dynamic jsonUtf8Decode(Uint8List bodyBytes) => json.decode(utf8.decode(bodyBytes));

extension BodyBytesDecoder on Uint8List {
  List<T> asListOf<T>(T Function(dynamic) converter) {
    final json = jsonUtf8Decode(this);
    return (json as List).map(converter).toList();
  }
}
