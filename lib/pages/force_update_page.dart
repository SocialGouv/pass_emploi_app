import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

import '../ui/strings.dart';

class ForceUpdatePage extends TraceableStatelessWidget {
  ForceUpdatePage() : super(name: AnalyticsScreenNames.forceUpdate);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Scaffold(
        appBar: DefaultAppBar(title: Text(Strings.update, style: TextStyles.h3Semi)),
        body: Padding(
          padding: const EdgeInsets.all(Margins.medium),
          child: Column(
            children: [
              Expanded(child: SvgPicture.asset(Drawables.icLogo, semanticsLabel: Strings.logoTextDescription)),
              Text(
                Strings.forceUpdateExplanation,
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
