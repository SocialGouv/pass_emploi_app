import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/tutorial/tutorial.dart';
import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';

class TutorialRepository {
  final FlutterSecureStorage _preferences;

  TutorialRepository(this._preferences);

  List<TutorialPage> getMiloTutorial() => Tutorial.milo;

  List<TutorialPage> getPoleEmploiTutorial() => Tutorial.pe;

  Future<void> setTutorialRead() async {
    await _preferences.write(key: 'tutorialRead-' + Tutorial.version, value: 'read');
  }

  Future<bool> shouldShowTutorial() async {
    final String? tutorialRead = await _preferences.read(key: 'tutorialRead-' + Tutorial.version);
    return tutorialRead == null;
  }
}
