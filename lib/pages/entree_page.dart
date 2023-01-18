import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/mode_demo/explication_page_mode_demo.dart';
import 'package:pass_emploi_app/pages/cej_information_page.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/presentation/device_info_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/entree_biseau_background.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class EntreePage extends StatelessWidget {
  static const minimum_height_to_see_jeune_face = 656;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Tracker(
      tracking: AnalyticsScreenNames.entree,
      child: Scaffold(
        body: Stack(
          children: [
            const EntreeBiseauBackground(),
            SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16),
                  SvgPicture.asset(Drawables.icUnJeuneUneSolution, width: screenWidth * 0.25),
                  SizedBox(height: 32),
                  _HiddenMenuGesture(
                    child: SvgPicture.asset(Drawables.cejAppLogo, width: screenWidth * 0.6),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: screenHeight >= minimum_height_to_see_jeune_face
                          ? Image.asset(Drawables.jeuneEntree, alignment: Alignment.bottomCenter)
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(Margins.spacing_m),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [Shadows.boxShadow],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Margins.spacing_base,
                        right: Margins.spacing_base,
                        top: Margins.spacing_base,
                      ),
                      child: _buttonCard(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buttonCard(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryActionButton(
          label: Strings.loginAction,
          onPressed: () => Navigator.push(context, LoginPage.materialPageRoute()),
        ),
        SizedBox(height: Margins.spacing_base),
        SecondaryButton(
          label: Strings.askAccount,
          onPressed: () => Navigator.push(context, CejInformationPage.materialPageRoute()),
        ),
        SepLine(Margins.spacing_base, 0),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(Strings.legalInformation, style: TextStyles.textBaseRegular),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.topLeft,
            children: [
              SizedBox(height: Margins.spacing_s),
              Link(Strings.legalNoticeLabel, Strings.legalNoticeUrl),
              SizedBox(height: Margins.spacing_m),
              Link(Strings.privacyPolicyLabel, Strings.privacyPolicyUrl),
              SizedBox(height: Margins.spacing_m),
              Link(Strings.termsOfServiceLabel, Strings.termsOfServiceUrl),
              SizedBox(height: Margins.spacing_m),
              Link(Strings.accessibilityLevelLabel, Strings.accessibilityUrl),
              SizedBox(height: Margins.spacing_m),
            ],
          ),
        )
      ],
    );
  }
}

class Link extends StatelessWidget {
  final String label;
  final String link;

  const Link(this.label, this.link, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          PassEmploiMatomoTracker.instance.trackOutlink(link);
          launchExternalUrl(link);
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(label, style: TextStyles.internalLink),
            SizedBox(width: Margins.spacing_s),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: SvgPicture.asset(Drawables.icRedirection, color: AppColors.primary),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _HiddenMenuGesture extends StatelessWidget {
  int _numberOfClicks = 0;

  final Widget child;

  _HiddenMenuGesture({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onClick(context),
      child: child,
    );
  }

  void _onClick(BuildContext context) {
    if (_numberOfClicks == 2) {
      _numberOfClicks = 0;
      _showHiddenMenu(context);
    } else {
      _numberOfClicks = _numberOfClicks + 1;
    }
  }

  void _showHiddenMenu(BuildContext context) {
    showModalBottomSheet<void>(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (context) => _HiddenMenu(),
    );
  }
}

class _HiddenMenu extends StatelessWidget {
  const _HiddenMenu();

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Margins.spacing_l, horizontal: Margins.spacing_l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PrimaryActionButton(
                label: Strings.passerEnDemo,
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDemo(context);
                },
              ),
              SizedBox(height: Margins.spacing_base),
              PrimaryActionButton(
                label: Strings.supportInformations,
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDeviceInfos(context);
                },
              ),
              SizedBox(height: Margins.spacing_base),
              SecondaryButton(
                label: Strings.close,
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ),
      ),
    ]);
  }

  void _showDemo(BuildContext context) {
    Navigator.push(context, ExplicationModeDemoPage.materialPageRoute());
  }

  void _showDeviceInfos(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _DeviceInfos(),
    );
  }
}

class _DeviceInfos extends StatelessWidget {
  const _DeviceInfos();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DeviceInfoViewModel>(
      converter: (store) => DeviceInfoViewModel.fromStore(store),
      builder: (context, viewmodel) => _DeviceInfosDialog(viewmodel),
      distinct: true,
    );
  }
}

class _DeviceInfosDialog extends StatelessWidget {
  final DeviceInfoViewModel viewmodel;

  _DeviceInfosDialog(this.viewmodel);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Device Infos'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('InstallationID', style: TextStyles.textBaseBold),
            Row(
              children: [
                Expanded(child: Text(viewmodel.installationId)),
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: viewmodel.installationId));
                    Navigator.of(context).pop();
                    showSuccessfulSnackBar(context, Strings.copie);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(Strings.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
