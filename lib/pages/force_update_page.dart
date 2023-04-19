import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/presentation/force_update_view_model.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/widgets/external_link.dart';

class ForceUpdatePage extends StatelessWidget {
  final Flavor _flavor;

  ForceUpdatePage(this._flavor);

  @override
  Widget build(BuildContext context) {
    final platform = io.Platform.isAndroid ? Platform.ANDROID : Platform.IOS;
    final viewModel = ForceUpdateViewModel.create(_flavor, platform);
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Tracker(
        tracking: AnalyticsScreenNames.forceUpdate,
        child: Scaffold(
          appBar: AppBar(title: Text(Strings.updateTitle)),
          body: Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: Column(
              children: [
                Expanded(child: SvgPicture.asset(Drawables.appLogo, semanticsLabel: Strings.logoDescription)),
                Text(viewModel.label, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
                if (viewModel.withCallToAction) ExternalLink(label: Strings.updateButton, url: viewModel.storeUrl),
                Expanded(child: SizedBox())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
