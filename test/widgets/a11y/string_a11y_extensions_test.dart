import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/widgets/a11y/string_a11y_extensions.dart';

void main() {
  group('toTimeAndDurationForScreenReaders', () {
    test('should replace : character', () {
      expect("17:30".toTimeAndDurationForScreenReaders(), "17 heures 30");
    });

    test('should replace h character', () {
      expect("1h30".toTimeAndDurationForScreenReaders(), "1 heures 30");
    });

    test('should replace min string', () {
      expect("30min".toTimeAndDurationForScreenReaders(), "30 minutes ");
    });

    test('should remove minutes when 00', () {
      expect("17:00".toTimeAndDurationForScreenReaders(), "17 heures ");
    });

    test('should add duration prefix', () {
      expect("(1h)".toTimeAndDurationForScreenReaders(), "(durée : 1 heures )");
    });
  });

  group('toFullDayForScreenReaders', () {
    test('should replace lun.', () {
      expect("lun.".toFullDayForScreenReaders(), "lundi");
    });

    test('should replace mar.', () {
      expect("mar.".toFullDayForScreenReaders(), "mardi");
    });

    test('should replace mer.', () {
      expect("mer.".toFullDayForScreenReaders(), "mercredi");
    });

    test('should replace jeu.', () {
      expect("jeu.".toFullDayForScreenReaders(), "jeudi");
    });

    test('should replace ven.', () {
      expect("ven.".toFullDayForScreenReaders(), "vendredi");
    });

    test('should replace sam.', () {
      expect("sam.".toFullDayForScreenReaders(), "samedi");
    });

    test('should replace dim.', () {
      expect("dim.".toFullDayForScreenReaders(), "dimanche");
    });
  });
}
