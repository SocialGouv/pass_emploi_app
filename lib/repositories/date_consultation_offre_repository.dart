import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DateConsultationOffreRepository {
  static const _key = "date_consultation_offre";

  final FlutterSecureStorage secureStorage;

  DateConsultationOffreRepository(this.secureStorage);

  Future<Map<String, DateTime>> get() async {
    final result = await secureStorage.read(key: _key);
    if (result == null) return {};
    return result.deserialize();
  }

  Future<void> set(String offreId, DateTime date) async {
    final dates = await get();
    dates[offreId] = date;
    // TODO: gérer la limite de stockage à 100 offres
    await secureStorage.write(key: _key, value: dates.serialize());
  }
}

extension on Map<String, DateTime> {
  String serialize() {
    final Map<String, String> offreIdToDateIso8601 = map((key, value) {
      return MapEntry(key, value.toIso8601String());
    });
    return json.encode(offreIdToDateIso8601);
  }
}

extension on String {
  Map<String, DateTime> deserialize() {
    final offreIdToDateIso8601 = Map<String, String>.from(json.decode(this) as Map<String, dynamic>);
    return offreIdToDateIso8601.map((key, value) {
      return MapEntry(key, DateTime.parse(value));
    });
  }
}
