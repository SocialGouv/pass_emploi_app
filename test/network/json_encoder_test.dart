import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_accepter_suggestion_alterte.dart';
import 'package:pass_emploi_app/network/put_configuration_application.dart';
import 'package:pass_emploi_app/network/put_user_action_request.dart';

import '../doubles/fixtures.dart';

void main() {
  test('customJsonEncode for PutUserActionRequest when status is DONE', () {
    final request = PutUserActionRequest(status: UserActionStatus.DONE);
    final json = customJsonEncode(request);
    expect(json, '{"status":"done"}');
  });

  test('customJsonEncode for PutUserActionRequest when status is IN_PROGRESS', () {
    final request = PutUserActionRequest(status: UserActionStatus.IN_PROGRESS);
    final json = customJsonEncode(request);
    expect(json, '{"status":"in_progress"}');
  });

  test('customJsonEncode for PutUserActionRequest when status is NOT_STARTED', () {
    final request = PutUserActionRequest(status: UserActionStatus.NOT_STARTED);
    final json = customJsonEncode(request);
    expect(json, '{"status":"not_started"}');
  });

  test('customJsonEncode for PutRegisterTokenRequest', () {
    final request = PutConfigurationApplication(token: 'token123', fuseauHoraire: "Europe/Paris");
    final json = customJsonEncode(request);
    expect(json, '{"registration_token":"token123","fuseauHoraire":"Europe/Paris"}');
  });

  test('customJsonEncode for PostAccepterSuggestionAlerte', () {
    final request = PostAccepterSuggestionAlerte(location: mockLocationParis(), rayon: null);
    final json = customJsonEncode(request);
    expect(json, '{"location":{"libelle":"Paris","code":"75","type":"DEPARTEMENT","latitude":1.0,"longitude":2.0}}');
  });
}
