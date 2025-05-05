part of '../create_demarche_form_view_model.dart';

class CreateDemarcheConfirmationStepViewModel extends CreateDemarcheViewModel {
  final bool valid;
  CreateDemarcheConfirmationStepViewModel({this.valid = true});

  @override
  List<Object?> get props => [valid];
}
