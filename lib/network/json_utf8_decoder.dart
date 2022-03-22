import 'dart:convert';
import 'dart:typed_data';

dynamic jsonUtf8Decode(Uint8List bodyBytes) => json.decode(utf8.decode(bodyBytes));
