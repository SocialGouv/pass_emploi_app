import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _maxLength = 100;

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
    final newDates = dates.removeOldestEntryIfRequired();
    await secureStorage.write(key: _key, value: newDates.serialize());
  }
}

extension on Map<String, DateTime> {
  String serialize() {
    final Map<String, String> offreIdToDateIso8601 = map((key, value) {
      return MapEntry(key, value.toIso8601String());
    });
    return json.encode(offreIdToDateIso8601);
  }

  Map<String, DateTime> removeOldestEntryIfRequired() {
    final copy = Map<String, DateTime>.from(this);
    while (copy.length > _maxLength) {
      final sortedDates = copy.entries.toList()..sort((entryA, entryB) => entryA.value.compareTo(entryB.value));
      copy.remove(sortedDates.first.key);
    }
    return copy;
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
