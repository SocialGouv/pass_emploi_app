import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/patch_user_action_request.dart';
import 'package:pass_emploi_app/network/put_register_token_request.dart';

void main() {
  test('customJsonEncode for PatchUserActionRequest when status is DONE', () {
    final request = PatchUserActionRequest(status: UserActionStatus.DONE);
    final json = customJsonEncode(request);
    expect(json, '{"status":"done"}');
  });

  test('customJsonEncode for PatchUserActionRequest when status is IN_PROGRESS', () {
    final request = PatchUserActionRequest(status: UserActionStatus.IN_PROGRESS);
    final json = customJsonEncode(request);
    expect(json, '{"status":"in_progress"}');
  });

  test('customJsonEncode for PatchUserActionRequest when status is NOT_STARTED', () {
    final request = PatchUserActionRequest(status: UserActionStatus.NOT_STARTED);
    final json = customJsonEncode(request);
    expect(json, '{"status":"not_started"}');
  });

  test('customJsonEncode for User', () {
    final user = User(id: "1", firstName: "first-name", lastName: "last-name");
    final json = customJsonEncode(user);
    expect(json, '{"id":"1","firstName":"first-name","lastName":"last-name"}');
  });

  test('customJsonEncode for PutRegisterTokenRequest', () {
    final request = PutRegisterTokenRequest(token: 'token123');
    final json = customJsonEncode(request);
    expect(json, '{"registration_token":"token123"}');
  });
}
