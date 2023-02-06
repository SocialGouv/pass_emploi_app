import 'package:equatable/equatable.dart';

abstract class ActionsRechercheViewModel extends Equatable {
  abstract final bool withAlertButton;
  abstract final bool withFiltreButton;
  abstract final int? filtresCount;
}
