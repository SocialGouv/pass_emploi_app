import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/drawables/app_logo.dart';
import 'package:pass_emploi_app/widgets/entree_biseau_background.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: PackageInfo.fromPlatform().then((platform) => platform.version),
      builder: (context, snapshot) {
        final appVersion = snapshot.data;
        return Scaffold(
          body: Stack(
            children: [
              EntreeBiseauBackground(),
              Center(child: AppLogo()),
              if (appVersion != null) _AppVersion(appVersion),
            ],
          ),
        );
      },
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
