import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class LoginViewModel extends Equatable {
  final String suiviText;
  final bool withAskAccountButton;
  final bool withLoading;
  final bool withWrongDeviceClockMessage;
  final String? technicalErrorMessage;

  LoginViewModel({
    required this.suiviText,
    required this.withAskAccountButton,
    required this.withLoading,
    required this.withWrongDeviceClockMessage,
    required this.technicalErrorMessage,
  });

  factory LoginViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final brand = store.state.configurationState.getBrand();
    return LoginViewModel(
      suiviText: brand.isCej ? Strings.suiviParConseillerCEJ : Strings.suiviParConseillerBRSA,
      withAskAccountButton: brand.isCej,
      withLoading: loginState is LoginLoadingState,
      withWrongDeviceClockMessage: loginState is LoginWrongDeviceClockState,
      technicalErrorMessage: loginState is LoginGenericFailureState ? loginState.message : null,
    );
  }

  @override
  List<Object?> get props => [
        suiviText,
        withAskAccountButton,
        withLoading,
        withWrongDeviceClockMessage,
        technicalErrorMessage,
      ];
}
