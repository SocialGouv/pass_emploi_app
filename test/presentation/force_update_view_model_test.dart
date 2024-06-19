import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/presentation/force_update_view_model.dart';
import 'package:pass_emploi_app/utils/platform.dart';

void main() {
  const stagingLabel = 'Votre application nécessite d\'être mise à jour sur Firebase pour son bon fonctionnement';
  const prodLabel = 'Votre application nécessite d\'être mise à jour pour son bon fonctionnement';

  const cejPlayStoreUrl = 'market://details?id=fr.fabrique.social.gouv.passemploi';
  const cejAppleStoreUrl = 'itms-apps://itunes.apple.com/app/apple-store/id1581603519';
  const passEmploiPlayStoreUrl = 'market://details?id=fr.fabrique.social.gouv.passemploi.rsa';
  const passEmploiAppleStoreUrl = 'itms-apps://itunes.apple.com/app/apple-store/id6448051621';

  group('ForceUpdateViewModel', () {
    const testCases = [
      {
        'brand': Brand.cej,
        'platform': Platform.ANDROID,
        'flavor': Flavor.STAGING,
        'withCallToAction': false,
        'expectedUrl': "",
        'expectedMessage': stagingLabel,
      },
      {
        'brand': Brand.cej,
        'platform': Platform.IOS,
        'flavor': Flavor.STAGING,
        'withCallToAction': false,
        'expectedUrl': "",
        'expectedMessage': stagingLabel,
      },
      {
        'brand': Brand.cej,
        'platform': Platform.ANDROID,
        'flavor': Flavor.PROD,
        'withCallToAction': true,
        'expectedUrl': cejPlayStoreUrl,
        'expectedMessage': prodLabel,
      },
      {
        'brand': Brand.cej,
        'platform': Platform.IOS,
        'flavor': Flavor.PROD,
        'withCallToAction': true,
        'expectedUrl': cejAppleStoreUrl,
        'expectedMessage': prodLabel,
      },
      {
        'brand': Brand.passEmploi,
        'platform': Platform.ANDROID,
        'flavor': Flavor.STAGING,
        'withCallToAction': false,
        'expectedUrl': "",
        'expectedMessage': stagingLabel,
      },
      {
        'brand': Brand.passEmploi,
        'platform': Platform.IOS,
        'flavor': Flavor.STAGING,
        'withCallToAction': false,
        'expectedUrl': "",
        'expectedMessage': stagingLabel,
      },
      {
        'brand': Brand.passEmploi,
        'platform': Platform.ANDROID,
        'flavor': Flavor.PROD,
        'withCallToAction': true,
        'expectedUrl': passEmploiPlayStoreUrl,
        'expectedMessage': prodLabel,
      },
      {
        'brand': Brand.passEmploi,
        'platform': Platform.IOS,
        'flavor': Flavor.PROD,
        'withCallToAction': true,
        'expectedUrl': passEmploiAppleStoreUrl,
        'expectedMessage': prodLabel,
      },
    ];

    for (var testCase in testCases) {
      final brand = testCase['brand'] as Brand;
      final platform = testCase['platform'] as Platform;
      final flavor = testCase['flavor'] as Flavor;
      final withCallToAction = testCase['withCallToAction'] as bool;
      final expectedUrl = testCase['expectedUrl'] as String;
      final expectedMessage = testCase['expectedMessage'] as String;

      test('create when brand is $brand, flavor is $flavor and platform is $platform', () {
        expect(
          ForceUpdateViewModel.create(brand, flavor, platform),
          ForceUpdateViewModel(
            label: expectedMessage,
            storeUrl: expectedUrl,
            withCallToAction: withCallToAction,
          ),
        );
      });
    }
  });
}
