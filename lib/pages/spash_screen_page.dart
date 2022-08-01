import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/entree_biseau_background.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.splash,
      child: FutureBuilder<String>(
        future: PackageInfo.fromPlatform().then((platform) => platform.version),
        builder: (context, snapshot) {
          final appVersion = snapshot.data;
          return Scaffold(
            body: Stack(
              children: [
                EntreeBiseauBackground(),
                Center(child: SvgPicture.asset(Drawables.cejAppLogo, semanticsLabel: Strings.logoTextDescription)),
                if (appVersion != null) _AppVersion(appVersion),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AppVersion extends StatelessWidget {
  final String _appVersion;

  const _AppVersion(this._appVersion);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: Text(
          _appVersion,
          style: TextStyles.textBaseBoldWithColor(Colors.white),
        ),
      ),
    );
  }
}
