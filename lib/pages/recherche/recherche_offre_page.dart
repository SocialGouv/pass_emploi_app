import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class RechercheOffrePage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheOffrePage());
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = AppColors.grey100;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: Strings.rechercheOffresEmploiTitle, backgroundColor: backgroundColor),
    );
  }
}
