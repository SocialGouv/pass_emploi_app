import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class SimpleConfirmationPage extends StatelessWidget {
  const SimpleConfirmationPage._(this.title);

  static Route<void> postuler() {
    return MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => SimpleConfirmationPage._(Strings.offrePostuleeConfirmationAppBar),
    );
  }

  static Route<void> favoris() {
    return MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => SimpleConfirmationPage._(Strings.offreFavorisConfirmationAppBar),
    );
  }

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SecondaryAppBar(title: title, backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: Margins.spacing_xl),
              Center(
                child: SizedBox(
                  height: 130,
                  width: 130,
                  child: Illustration.green(AppIcons.check_rounded),
                ),
              ),
              SizedBox(height: Margins.spacing_xl),
              Text(
                Strings.offreSuivieConfirmationPageTitle,
                textAlign: TextAlign.center,
                style: TextStyles.textMBold,
              ),
              SizedBox(height: Margins.spacing_base),
              Text(
                Strings.offreSuivieConfirmationPageDescription,
                textAlign: TextAlign.center,
                style: TextStyles.textBaseRegular,
              ),
              SizedBox(height: Margins.spacing_l),
              PrimaryActionButton(label: Strings.understood, onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}
