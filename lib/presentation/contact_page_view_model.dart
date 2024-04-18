import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class ContactPageViewModel extends Equatable {
  final String emailSubject;

  ContactPageViewModel({required this.emailSubject});

  factory ContactPageViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final brand = store.state.configurationState.getBrand();
    return ContactPageViewModel(
      emailSubject: _emailSubject(loginState, brand),
    );
  }

  @override
  List<Object?> get props => [emailSubject];
}

String _emailSubject(LoginState loginState, Brand brand) {
  String subjectPrefix = "";
  if (loginState is LoginSuccessState) {
    final loginMode = loginState.user.loginMode;
    subjectPrefix = switch (loginMode) {
      LoginMode.MILO => Strings.milo,
      LoginMode.POLE_EMPLOI => Strings.poleEmploi,
      LoginMode.DEMO_MILO => Strings.demoMilo,
      LoginMode.DEMO_PE => Strings.demoPe,
      LoginMode.PASS_EMPLOI => Strings.passEmploi,
    };
  }

  return "$subjectPrefix - ${Strings.objetPriseDeContact(brand)}";
}
