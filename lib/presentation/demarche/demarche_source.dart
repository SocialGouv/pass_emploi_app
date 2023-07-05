sealed class DemarcheSource {}

class RechercheDemarcheSource extends DemarcheSource {}

class ThematiquesDemarcheSource extends DemarcheSource {
  final String thematiqueCode;

  ThematiquesDemarcheSource(this.thematiqueCode);
}
