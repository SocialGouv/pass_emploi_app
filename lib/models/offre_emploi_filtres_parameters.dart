class OffreEmploiSearchParametersFiltres {
  final int? distance;

  OffreEmploiSearchParametersFiltres._({
    this.distance,
  });

  factory OffreEmploiSearchParametersFiltres.withFiltres({
    int? distance,
  }) {
    return OffreEmploiSearchParametersFiltres._(
      distance: distance,
    );
  }

  factory OffreEmploiSearchParametersFiltres.noFiltres() {
    return OffreEmploiSearchParametersFiltres._(
      distance: null,
    );
  }
}
