class AlerteCreateRequestAction<T> {
  final T alerte;
  final String title;

  AlerteCreateRequestAction(this.alerte, this.title);
}

class AlerteCreateInitializeAction<T> {
  final T alerte;

  AlerteCreateInitializeAction(this.alerte);
}

class AlerteCreateLoadingAction<T> {}

class AlerteCreateSuccessAction<T> {
  final T search;

  AlerteCreateSuccessAction(this.search);
}

class AlerteCreateFailureAction<T> {}

class AlerteCreateResetAction<T> {}
