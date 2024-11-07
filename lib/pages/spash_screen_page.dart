import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_action.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/biseau_background.dart';
import 'package:pass_emploi_app/widgets/drawables/app_logo.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/wrappers/package_info_wrapper.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: PackageInfoWrapper.getVersion(),
      builder: (context, snapshot) {
        final appVersion = snapshot.data;
        return Scaffold(
          body: Stack(
            children: [
              BiseauBackground(),
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
      child: GestureDetector(
        onDoubleTap: () {
          context.dispatch(DeveloperOptionsDeleteAllPrefsAction());
          showSnackBarWithSystemError(context, "Killez 💀- voire supprimer 🗑 - l'app");
        },
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: Text(
            _appVersion,
            style: TextStyles.textBaseBoldWithColor(Colors.white),
          ),
        ),
      ),
    );
  }
}
