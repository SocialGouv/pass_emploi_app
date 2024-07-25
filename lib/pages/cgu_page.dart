import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/cgu_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/primary_rounded_bottom_background.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class CguPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.cguPage,
      child: StoreConnector<AppState, CguPageViewModel>(
        builder: (context, viewModel) => _Scaffold(viewModel),
        converter: CguPageViewModel.create,
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  final CguPageViewModel viewModel;

  const _Scaffold(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PrimaryRoundedBottomBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: Margins.spacing_m,
                right: Margins.spacing_m,
                top: Margins.spacing_huge,
                bottom: Margins.spacing_l,
              ),
              child: _Body(
                viewModel,
                child: switch (viewModel.displayState) {
                  CguNeverAcceptedDisplayState() => _CguNeverAcceptedContent(),
                  final CguUpdateRequiredDisplayState vm => _CguUpdateRequiredContent(vm),
                  null => SizedBox.shrink(),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final CguPageViewModel viewModel;
  final Widget child;

  const _Body(this.viewModel, {required this.child});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _acceptCguButtonClicked = false;
  bool _cguAccepted = false;

  @override
  Widget build(BuildContext context) {
    final bool neverAccepted = widget.viewModel.displayState is CguNeverAcceptedDisplayState;
    return Column(
      children: [
        Expanded(
          child: CardContainer(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: Margins.spacing_m),
              child: Column(
                children: [
                  widget.child,
                  SizedBox(height: Margins.spacing_m),
                  SepLine(
                    Margins.spacing_m,
                    Margins.spacing_m,
                    color: AppColors.grey100,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _launchExternalRedirect,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: neverAccepted
                                      ? Strings.cguNeverAcceptedSwitch[0]
                                      : Strings.cguUpdateRequiredSwitch[0],
                                  style: _cguSwitchTestStyle(),
                                ),
                                TextSpan(
                                  text: neverAccepted
                                      ? Strings.cguNeverAcceptedSwitch[1]
                                      : Strings.cguUpdateRequiredSwitch[1],
                                  style: _cguSwitchTestStyle(underlined: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Margins.spacing_m),
                      Semantics(
                        label: Strings.cguSwitchLabel(_cguAccepted),
                        child: Switch(
                          value: _cguAccepted,
                          onChanged: (value) => setState(() => _cguAccepted = value),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Margins.spacing_base),
                  if (shouldHighlightError())
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(AppIcons.error_rounded, color: AppColors.warning),
                        SizedBox(width: Margins.spacing_s),
                        Expanded(
                          child: Text(
                            Strings.cguSwitchError,
                            style: TextStyles.textXsRegular(color: AppColors.warning),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: Margins.spacing_l),
        SizedBox(
          width: double.infinity,
          child: PrimaryActionButton(
            label: Strings.cguAccept,
            onPressed: () {
              setState(() => _acceptCguButtonClicked = true);
              if (_cguAccepted) widget.viewModel.onAccept();
            },
          ),
        ),
        SizedBox(height: Margins.spacing_s),
        SizedBox(
          width: double.infinity,
          child: SecondaryButton(
            backgroundColor: Colors.transparent,
            label: Strings.cguRefuse,
            onPressed: () => widget.viewModel.onRefuse(),
          ),
        ),
      ],
    );
  }

  TextStyle _cguSwitchTestStyle({bool underlined = false}) {
    var style = shouldHighlightError() ? TextStyles.textSBoldWithColor(AppColors.warning) : TextStyles.textSRegular();
    if (underlined) style = style.copyWith(decoration: TextDecoration.underline);
    return style;
  }

  bool shouldHighlightError() => _acceptCguButtonClicked && !_cguAccepted;
}

class _CguNeverAcceptedContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          Strings.cguNeverAcceptedTitle,
          style: TextStyles.textLBold(color: AppColors.primary),
        ),
        SizedBox(height: Margins.spacing_m),
        GestureDetector(
          onTap: _launchExternalRedirect,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: Strings.cguNeverAcceptedDescription[0],
                  style: TextStyles.textBaseRegular,
                ),
                TextSpan(
                  text: Strings.cguNeverAcceptedDescription[1],
                  style: TextStyles.textBaseRegular.copyWith(
                    color: AppColors.contentColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: Strings.cguNeverAcceptedDescription[2],
                  style: TextStyles.textBaseRegular,
                ),
                TextSpan(
                  text: Strings.cguNeverAcceptedDescription[3],
                  style: TextStyles.textBaseBold,
                ),
                TextSpan(
                  text: Strings.cguNeverAcceptedDescription[4],
                  style: TextStyles.textBaseRegular,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CguUpdateRequiredContent extends StatelessWidget {
  final CguUpdateRequiredDisplayState displayState;

  const _CguUpdateRequiredContent(this.displayState);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          Strings.cguUpdateRequiredTitle,
          style: TextStyles.textLBold(color: AppColors.primary),
        ),
        SizedBox(height: Margins.spacing_m),
        GestureDetector(
          onTap: _launchExternalRedirect,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: Strings.cguUpdateRequiredDescription[0] +
                      displayState.lastUpdateLabel +
                      Strings.cguUpdateRequiredDescription[1],
                  style: TextStyles.textBaseRegular,
                ),
                TextSpan(
                  text: Strings.cguUpdateRequiredDescription[2],
                  style: TextStyles.textBaseRegular.copyWith(
                    color: AppColors.contentColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: Strings.cguUpdateRequiredDescription[3],
                  style: TextStyles.textBaseRegular,
                ),
                for (var change in displayState.changes)
                  TextSpan(
                    text: " • $change\n",
                    style: TextStyles.textBaseRegular,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void _launchExternalRedirect() {
  PassEmploiMatomoTracker.instance.trackOutlink(Strings.termsOfServiceUrl);
  launchExternalUrl(Strings.termsOfServiceUrl);
}
