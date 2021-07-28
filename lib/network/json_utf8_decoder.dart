import 'dart:convert';

dynamic jsonUtf8Decode(bodyBytes) => json.decode(utf8.decode(bodyBytes));
