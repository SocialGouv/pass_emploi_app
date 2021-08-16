import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/patch_user_action_request.dart';

void main() {
  test('customJsonEncode for PatchUserActionRequest', () {
    final request = PatchUserActionRequest(isDone: false);
    final json = customJsonEncode(request);
    expect(json, '{"isDone":false}');
  });
}
