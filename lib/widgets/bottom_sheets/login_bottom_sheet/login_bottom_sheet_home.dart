import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/login_bottom_sheet/login_bottom_sheet_page1.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/login_bottom_sheet/login_bottom_sheet_page2.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const LoginBottomSheet(),
    );
  }

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  int index = 0;
  void loginModeSelected() => setState(() => index = 1);

  @override
  Widget build(BuildContext context) {
    final pages = [
      LoginBottomSheetPage1(loginModeSelected: loginModeSelected),
      LoginBottomSheetPage2(),
    ];

    return BottomSheetWrapper(
      title: "",
      body: AnimatedSwitcher(
        duration: AnimationDurations.fast,
        child: pages[index],
      ),
    );
  }
}
