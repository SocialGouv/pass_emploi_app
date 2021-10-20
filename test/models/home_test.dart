import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/home.dart';
import 'package:pass_emploi_app/models/user_action.dart';

import '../utils/test_assets.dart';

void main() {
  test('Home.fromJson when complete data should deserialize data correctly', () {
    final String homeString = loadTestAssets("home.json");
    final homeJson = json.decode(homeString);

    final Home home = Home.fromJson(homeJson);

    final conseiller = home.conseiller;
    expect(conseiller.id, "1");
    expect(conseiller.firstName, "Nils");
    expect(conseiller.lastName, "Tavernier");

    expect(home.doneActionsCount, 3);

    expect(home.actions.length, 5);
    final action = home.actions.first;
    expect(action.id, "8802034");
    expect(action.content, "Changer de prénom");
    expect(action.comment, "Commentaire");
    expect(action.status, UserActionStatus.DONE);
    expect(action.lastUpdate, DateTime(2021, 7, 30, 9, 43, 9));

    expect(home.rendezvous.length, 2);
    final rendezvous = home.rendezvous.first;
    expect(rendezvous.id, "8230054");
    expect(rendezvous.date, DateTime(2022, 12, 23, 0, 0, 0));
    expect(rendezvous.title, "Rendez-vous conseiller");
    expect(rendezvous.subtitle, "Avec Nils");
    expect(rendezvous.comment, "Préparation aux entretiens");
    expect(rendezvous.duration, "1:00:00");
    expect(rendezvous.modality, "Par tel");
  });
}
