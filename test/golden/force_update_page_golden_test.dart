import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/pages/force_update_page.dart';

void main() {
  testWidgets('Force update page on PROD flavor should allow redirection to app store', (WidgetTester tester) async {
    // Given
    const prod = Flavor.PROD;

    // When
    await tester.pumpWidget(ForceUpdatePage(prod));

    // Then
    expect(find.text('Mettre à jour'), findsOneWidget);
  });
}
