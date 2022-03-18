import 'package:pass_emploi_app/models/metier.dart';

class MetierRepository {
   Future<List<Metier>> getMetiers(String userInput) async {
    if (userInput.length < 2 || userInput.isEmpty) return [];
    return Metier.values.where((metier) {
      return _sanitizeString(metier.libelle).contains(_sanitizeString(userInput));
    }).toList();
  }

  String _sanitizeString(String str) {
    return _removeDiacritics(str).replaceAll(RegExp("[-'` ]"), "").trim().toUpperCase();
  }

  String _removeDiacritics(String str) {
    const withDia = 'ÀÁÂÃÄàáâäÒÓÔÕÕÖòóôõöÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûü';
    const withoutDia = 'AAAAAaaaaOOOOOOoooooEEEEeeeeCcIIIIiiiiUUUUuuuu';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }
}
