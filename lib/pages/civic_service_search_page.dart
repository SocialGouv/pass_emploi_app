import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/action_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class CivicServiceSearchPage extends TraceableStatelessWidget {
  CivicServiceSearchPage() : super(name: AnalyticsScreenNames.civicService);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 36),
          Text(Strings.civicServiceTitle, style: TextStyles.textSmMedium()),
          SizedBox(height: 24),
          Text(Strings.civicServiceContent, style: TextStyles.textSmRegular()),
          SizedBox(height: 36),
          Row(
            children: [
              Expanded(
                  child: actionButton(
                      onPressed: () => launch(Strings.civicServiceUrl), label: Strings.civicServiceButtonAction)),
            ],
          ),
        ],
      ),
    );
  }
}
