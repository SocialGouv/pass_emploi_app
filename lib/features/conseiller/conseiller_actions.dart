import 'package:pass_emploi_app/models/MonConseillerInfo.dart';

class ConseillerRequestAction {}

class ConseillerLoadingAction {}

class ConseillerSuccessAction {
  final MonConseillerInfo conseillerInfo;
  ConseillerSuccessAction({required this.conseillerInfo});
}

class ConseillerFailureAction {}
