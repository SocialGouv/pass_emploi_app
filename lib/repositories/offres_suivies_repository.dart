import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/offre_suivie.dart';

const _maxLength = 20;

class OffresSuiviesRepository {
  static const _key = "offres_suivies";

  final FlutterSecureStorage secureStorage;

  OffresSuiviesRepository(this.secureStorage);

  Future<List<OffreSuivie>> get() async {
    final result = await secureStorage.read(key: _key);
    if (result == null) return [];
    return result.deserialize();
  }

  Future<List<OffreSuivie>> set(OffreSuivie offre) async {
    final offres = await get();

    final existeDeja = offres.any((o) => o.offreDto == offre.offreDto);

    if (!existeDeja) {
      offres.add(offre);
      final newOffres = offres.removeOldestEntryIfRequired();
      await secureStorage.write(key: _key, value: newOffres.serialize());

      return newOffres;
    }

    return offres;
  }

  Future<List<OffreSuivie>> delete(OffreSuivie offre) async {
    final offres = await get();
    offres.remove(offre);
    await secureStorage.write(key: _key, value: offres.serialize());
    return offres;
  }
}

extension on List<OffreSuivie> {
  String serialize() {
    final List<Map<String, dynamic>> offres = map((offre) {
      return offre.toJson();
    }).toList();
    return jsonEncode(offres);
  }

  List<OffreSuivie> removeOldestEntryIfRequired() {
    return length > _maxLength ? sublist(length - _maxLength) : this;
  }
}

extension on String {
  List<OffreSuivie> deserialize() {
    try {
      final offres = List<Map<String, dynamic>>.from(json.decode(this) as List<dynamic>);
      return offres.map((offre) {
        return OffreSuivie.fromJson(offre);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
