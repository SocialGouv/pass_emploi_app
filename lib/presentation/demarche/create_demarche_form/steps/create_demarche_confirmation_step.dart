part of '../create_demarche_form_view_model.dart';

class CreateDemarche2ConfirmationStepViewModel extends CreateDemarche2ViewModel {
  final bool valid;
  CreateDemarche2ConfirmationStepViewModel({this.valid = true});

  @override
  bool get isValid => valid;

  @override
  List<Object?> get props => [valid];
}
