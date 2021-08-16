import 'dart:convert';

import 'package:pass_emploi_app/network/patch_user_action_request.dart';

String customJsonEncode(Object value) {
  return jsonEncode(value, toEncodable: (value) {
    if (value is PatchUserActionRequest) return value.toJson();
    return value;
  });
}
