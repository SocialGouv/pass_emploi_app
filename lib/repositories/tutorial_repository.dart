import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/tutorial/tutorial.dart';

class TutorialRepository {
  final FlutterSecureStorage _preferences;

  TutorialRepository(this._preferences);

  List<Tutorial> getMiloTutorial() => Tutorial.milo.toList();

  List<Tutorial> getPoleEmploiTutorial() => Tutorial.poleEmploi.toList();

  Future<void> setTutorialRead() async {
    await _preferences.write(key: 'tutorialRead-' + Tutorial.version, value: 'read');
  }

  Future<bool> shouldShowTutorial() async {
    final String? tutorialRead = await _preferences.read(key: 'tutorialRead-' + Tutorial.version);
    return tutorialRead == null;
  }
}
