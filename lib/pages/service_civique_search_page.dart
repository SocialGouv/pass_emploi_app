import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceCiviqueSearchPage extends TraceableStatelessWidget {
  ServiceCiviqueSearchPage() : super(name: AnalyticsScreenNames.serviceCiviqueResearch);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Margins.spacing_l),
          Text(Strings.serviceCiviqueTitle, style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_m),
          Text(Strings.serviceCiviqueContent, style: TextStyles.textBaseRegular),
          SizedBox(height: Margins.spacing_l),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: PrimaryActionButton(
              onPressed: () {
                MatomoTracker.trackScreenWithName(
                    Strings.serviceCiviqueUrl, AnalyticsScreenNames.serviceCiviqueResearch);
                launch(Strings.serviceCiviqueUrl);
              },
              label: Strings.serviceCiviqueButtonAction,
              drawableRes: Drawables.icLaunch,
              iconSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
