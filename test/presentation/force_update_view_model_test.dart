import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/presentation/force_update_view_model.dart';
import 'package:pass_emploi_app/utils/platform.dart';

void main() {
  test('create when flavor is STAGING', () {
    expect(
      ForceUpdateViewModel.create(Flavor.STAGING, Platform.ANDROID),
      ForceUpdateViewModel(
        label: 'Votre application nécessite d\'être mise à jour sur Firebase pour son bon fonctionnement',
        storeUrl: '',
        withCallToAction: false,
      ),
    );
  });

  test('create when flavor is PROD and platform is ANDROID', () {
    expect(
      ForceUpdateViewModel.create(Flavor.PROD, Platform.ANDROID),
      ForceUpdateViewModel(
        label: 'Votre application nécessite d\'être mise à jour pour son bon fonctionnement',
        storeUrl: 'market://details?id=fr.fabrique.social.gouv.passemploi',
        withCallToAction: true,
      ),
    );
  });

  test('create when flavor is PROD and platform is iOS', () {
    expect(
      ForceUpdateViewModel.create(Flavor.PROD, Platform.IOS),
      ForceUpdateViewModel(
        label: 'Votre application nécessite d\'être mise à jour pour son bon fonctionnement',
        storeUrl: 'itms-apps://itunes.apple.com/app/apple-store/id1581603519',
        withCallToAction: true,
      ),
    );
  });
}
