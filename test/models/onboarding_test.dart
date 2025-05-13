import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/onboarding.dart';

void main() {
  test('isCompleted should return true if all steps are completed', () {
    final onboarding = Onboarding(
      messageCompleted: true,
      actionCompleted: true,
      offreCompleted: true,
      evenementCompleted: true,
      outilsCompleted: true,
    );

    expect(onboarding.isCompleted(Accompagnement.cej), isTrue);
  });

  test('isCompleted should return false if any step is not completed', () {
    final onboarding = Onboarding(
      messageCompleted: true,
      actionCompleted: true,
      offreCompleted: true,
      evenementCompleted: true,
      outilsCompleted: false,
    );

    expect(onboarding.isCompleted(Accompagnement.cej), isFalse);
  });

  test('isCompleted should return true if action is not required', () {
    final onboarding = Onboarding(
      messageCompleted: true,
      actionCompleted: false,
      offreCompleted: true,
      evenementCompleted: true,
      outilsCompleted: true,
    );

    expect(onboarding.isCompleted(Accompagnement.avenirPro), isTrue);
  });
}
