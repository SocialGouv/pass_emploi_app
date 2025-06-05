sealed class CreateDemarcheDisplayState {
  static int get stepsTotalCount => 3;

  int index();
}

// step 1
class CreateDemarcheStep1 extends CreateDemarcheDisplayState {
  @override
  int index() => 0;
}

// step 2
sealed class CreateDemarcheStep2 extends CreateDemarcheDisplayState {
  @override
  int index() => 1;
}

class CreateDemarcheFromThematiqueStep2 extends CreateDemarcheStep2 {}

class CreateDemarchePersonnaliseeStep2 extends CreateDemarcheStep2 {}

class CreateDemarcheIaFtStep2 extends CreateDemarcheStep2 {}

// step 3
sealed class CreateDemarcheStep3 extends CreateDemarcheDisplayState {
  @override
  int index() => 2;
}

class CreateDemarcheFromThematiqueStep3 extends CreateDemarcheStep3 {}

class CreateDemarchePersonnaliseeStep3 extends CreateDemarcheStep3 {}

class CreateDemarcheIaFtStep3 extends CreateDemarcheStep3 {}

// confirmation
sealed class CreateDemarcheSubmitted extends CreateDemarcheDisplayState {
  @override
  int index() => 2;
}

class CreateDemarcheFromThematiqueSubmitted extends CreateDemarcheSubmitted {}

class CreateDemarchePersonnaliseeSubmitted extends CreateDemarcheSubmitted {}
