import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/derniere_offre_consultee.dart';

class DerniereOffreConsulteeRepository {
  static const _key = "derniere_offre_consultee";

  final FlutterSecureStorage secureStorage;

  DerniereOffreConsulteeRepository(this.secureStorage);

  Future<DerniereOffreConsultee?> get() async {
    final result = await secureStorage.read(key: _key);
    if (result == null) return null;
    return DerniereOffreConsultee.fromJson(json.decode(result));
  }

  Future<void> set(DerniereOffreConsultee offre) async {
    final String serializedOffre = json.encode(offre);
    await secureStorage.write(key: _key, value: serializedOffre);
  }
}
