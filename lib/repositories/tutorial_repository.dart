import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/tutorial.dart';

class TutorialRepository {
  final FlutterSecureStorage _preferences;

  TutorialRepository(this._preferences);

  Future<List<Tutorial>> getMiloTutorial() async {
    return await _shouldShowTutorial() ? Tutorial.milo.toList() : [];
  }

  Future<List<Tutorial>> getPoleEmploiTutorial() async {
    return await _shouldShowTutorial() ? Tutorial.poleEmploi.toList() : [];
  }

  Future<void> setTutorialRead() async {
    await _preferences.write(key: 'tutorialRead-' + Tutorial.version, value: 'read');
  }

  Future<bool> _shouldShowTutorial() async {
    final String? tutorialRead = await _preferences.read(key: 'tutorialRead-' + Tutorial.version);
    return tutorialRead == null;
  }
}
