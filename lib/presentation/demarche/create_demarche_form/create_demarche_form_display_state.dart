sealed class CreateDemarcheDisplayState {
  static int get stepsTotalCount => 3;

  int index();
}

// step 1
class CreateDemarche2Step1 extends CreateDemarcheDisplayState {
  @override
  int index() => 0;
}

// step 2
sealed class CreateDemarcheStep2 extends CreateDemarcheDisplayState {}

class CreateDemarche2FromThematiqueStep2 extends CreateDemarcheStep2 {
  @override
  int index() => 1;
}

class CreateDemarche2PersonnaliseeStep2 extends CreateDemarcheStep2 {
  @override
  int index() => 1;
}

// step 3
sealed class CreateDemarcheStep3 extends CreateDemarcheDisplayState {}

class CreateDemarche2FromThematiqueStep3 extends CreateDemarcheStep3 {
  @override
  int index() => 2;
}

class CreateDemarche2PersonnaliseeStep3 extends CreateDemarcheStep3 {
  @override
  int index() => 2;
}

// confirmation
class CreateDemarche2ConfirmationStep extends CreateDemarcheDisplayState {
  @override
  int index() => 2;
}
