import 'dart:convert';

import 'package:pass_emploi_app/network/json_serializable.dart';

String customJsonEncode(JsonSerializable value) => jsonEncode(value.toJson());
