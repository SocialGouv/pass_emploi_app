import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/login_view_model.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/login_bottom_sheet/login_bottom_sheet_page1.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/login_bottom_sheet/login_bottom_sheet_page2.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key, required this.loginButtons});

  final List<LoginButtonViewModel> loginButtons;

  static void show(BuildContext context, List<LoginButtonViewModel> loginButtons) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => LoginBottomSheet(loginButtons: loginButtons),
    );
  }

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  void loginModeSelected(LoginButtonViewModel button) => setState(() => selectedLoginMode = button);
  LoginButtonViewModel? selectedLoginMode;

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      heightFactor: 0.8,
      title: "",
      body: SingleChildScrollView(
        child: AnimatedSwitcher(
          duration: AnimationDurations.fast,
          child: selectedLoginMode != null
              ? LoginBottomSheetPage2(viewModel: selectedLoginMode!)
              : LoginBottomSheetPage1(
                  loginButtons: widget.loginButtons,
                  onLoginButtonSelected: loginModeSelected,
                ),
        ),
      ),
    );
  }
}
