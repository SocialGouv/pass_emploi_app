import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/utils/uri_handler.dart';

void main() {
  test('phone', () {
    expect(UriHandler().phoneUri("0701020304").toString(), "tel:0701020304");
  });

  test('mail', () {
    expect(
      UriHandler().mailUri(to: "name@beta.gouv.fr", subject: "Objet du mail").toString(),
      "mailto:name@beta.gouv.fr?subject=Objet%20du%20mail",
    );
  });

  test('maps Android', () {
    expect(
      UriHandler().mapsUri("55 Rue du Faubourg Saint-Honoré, 75008 Paris", Platform.ANDROID).toString(),
      "geo:0,0?q=55%20Rue%20du%20Faubourg%20Saint-Honor%C3%A9%2C%2075008%20Paris",
    );
  });

  test('maps iOS', () {
    expect(
      UriHandler().mapsUri("55 Rue du Faubourg Saint-Honoré, 75008 Paris", Platform.IOS).toString(),
      "https://maps.apple.com/maps?q=55+Rue+du+Faubourg+Saint-Honor%C3%A9%2C+75008+Paris",
    );
  });
}
