import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class ForceUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pass Emploi',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Scaffold(
        appBar: DefaultAppBar(title: Text('Mise à jour', style: TextStyles.h3Semi)),
        body: Padding(
          padding: const EdgeInsets.all(Margins.medium),
          child: Column(
            children: [
              Expanded(child: SvgPicture.asset("assets/ic_logo.svg", semanticsLabel: 'Logo Pass Emploi')),
              Text(
                'Votre application nécessite d\'être mise à jour pour son bon fonctionnement.',
                style: TextStyles.textMdRegular,
                textAlign: TextAlign.center,
              ),
              Expanded(child: SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}
