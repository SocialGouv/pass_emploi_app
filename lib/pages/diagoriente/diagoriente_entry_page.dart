import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class DiagorienteEntryPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => DiagorienteEntryPage());

  @override
  Widget build(BuildContext context) {
    const backgroundColor = AppColors.grey100;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: Strings.diagorienteEntryPageTitle, backgroundColor: backgroundColor),
      body: PrimaryActionButton(
        label: 'Commencer',
        onPressed: () {},
      ),
    );
  }
}
