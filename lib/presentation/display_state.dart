enum DisplayState {
  contenu,
  chargement,
  erreur,
  vide;

  bool isLoading() => this == DisplayState.chargement;

  bool isFailure() => this == DisplayState.erreur;

  bool isEmpty() => this == DisplayState.vide;
}
