import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/presentation/force_update_view_model.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/strings.dart';

class ForceUpdatePage extends TraceableStatelessWidget {
  final Flavor _flavor;

  ForceUpdatePage(this._flavor) : super(name: AnalyticsScreenNames.forceUpdate);

  @override
  Widget build(BuildContext context) {
    final platform = io.Platform.isAndroid ? Platform.ANDROID : Platform.IOS;
    final viewModel = ForceUpdateViewModel.create(_flavor, platform);
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Scaffold(
        appBar: passEmploiAppBar(
          label: Strings.updateTitle,
        ),
        body: Padding(
          padding: const EdgeInsets.all(Margins.medium),
          child: Column(
            children: [
              Expanded(child: SvgPicture.asset(Drawables.icLogo, semanticsLabel: Strings.logoTextDescription)),
              Text(viewModel.label, style: TextStyles.textMdRegular, textAlign: TextAlign.center),
              if (viewModel.withCallToAction)
                TextButton(
                  onPressed: () => launch(viewModel.storeUrl),
                  child: Text(Strings.updateButton, style: TextStyles.externalLink),
                ),
              Expanded(child: SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}
