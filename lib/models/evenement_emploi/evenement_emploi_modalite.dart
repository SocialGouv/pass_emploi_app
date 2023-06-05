enum EvenementEmploiModalite {
  enPhysique,
  aDistance;

  static EvenementEmploiModalite? from(String value) {
    return switch (value) {
      'en physique' => EvenementEmploiModalite.enPhysique,
      'a distance' => EvenementEmploiModalite.aDistance,
      _ => null,
    };
  }
}
