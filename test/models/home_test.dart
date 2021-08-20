import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/home.dart';

import '../utils/test_assets.dart';

void main() {
  test('Home.fromJson when complete data should unserialized correctly data', () {
    final String homeString = loadTestAssets("home.json");
    final homeJson = json.decode(homeString);

    final Home home = Home.fromJson(homeJson);

    expect(home.actions.length, 5);
    final action = home.actions.first;
    expect(action.content, "Changer de prénom");
    expect(action.id, "8802034");
    expect(action.isDone, true);
    expect(action.lastUpdate, DateTime(2021, 7, 30, 9, 43, 9));
    final conseiller = home.conseiller;
    expect(conseiller.id, "1");
    expect(conseiller.firstName, "Nils");
    expect(conseiller.lastName, "Tavernier");
  });
}
