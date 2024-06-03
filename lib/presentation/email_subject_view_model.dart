import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class EmailObjectViewModel extends Equatable {
  final String contactEmailObject;
  final String ratingEmailObject;

  EmailObjectViewModel({
    required this.contactEmailObject,
    required this.ratingEmailObject,
  });

  factory EmailObjectViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final brand = store.state.configurationState.getBrand();
    return EmailObjectViewModel(
      contactEmailObject: _emailSubject(loginState, brand),
      ratingEmailObject: _ratingSubject(loginState, brand),
    );
  }

  @override
  List<Object?> get props => [contactEmailObject, ratingEmailObject];
}

String _emailSubject(LoginState loginState, Brand brand) {
  return "${_emailObjectPrefix(loginState)} - ${Strings.objetPriseDeContact(brand)}";
}

String _ratingSubject(LoginState loginState, Brand brand) {
  return "${_emailObjectPrefix(loginState)} - ${Strings.ratingEmailObject(brand)}";
}

String _emailObjectPrefix(LoginState loginState) {
  if (loginState is LoginSuccessState) {
    return switch (loginState.user.loginMode) {
      LoginMode.MILO => Strings.milo,
      LoginMode.POLE_EMPLOI => Strings.poleEmploi,
      LoginMode.DEMO_MILO => Strings.demoMilo,
      LoginMode.DEMO_PE => Strings.demoPe,
      LoginMode.PASS_EMPLOI => Strings.passEmploi,
    };
  }
  return '';
}
