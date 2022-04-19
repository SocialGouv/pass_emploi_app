import 'package:pass_emploi_app/models/details_jeune.dart';

class DetailsJeuneRequestAction {}

class DetailsJeuneLoadingAction {}

class DetailsJeuneSuccessAction {
  final DetailsJeune detailsJeune;
  DetailsJeuneSuccessAction({required this.detailsJeune});
}

class DetailsJeuneFailureAction {}
