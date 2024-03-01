import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class EntreePageViewModel extends Equatable {
  final bool withRequestAccountButton;
  final bool withLoading;
  final bool withWrongDeviceClockMessage;
  final String? technicalErrorMessage;

  EntreePageViewModel({
    required this.withRequestAccountButton,
    required this.withLoading,
    required this.withWrongDeviceClockMessage,
    required this.technicalErrorMessage,
  });

  factory EntreePageViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final brand = store.state.configurationState.getBrand();
    return EntreePageViewModel(
      withRequestAccountButton: brand.isCej,
      withLoading: loginState is LoginLoadingState,
      withWrongDeviceClockMessage: loginState is LoginWrongDeviceClockState,
      technicalErrorMessage: loginState is LoginGenericFailureState ? loginState.message : null,
    );
  }

  @override
  List<Object?> get props => [
        withRequestAccountButton,
        withLoading,
        withWrongDeviceClockMessage,
        technicalErrorMessage,
      ];
}
