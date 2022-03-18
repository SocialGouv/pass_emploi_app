import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_details_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

import '../buttons/primary_action_button.dart';
import 'bottom_sheets.dart';

class UserActionDetailsBottomSheet extends TraceableStatefulWidget {
  final UserActionViewModel actionViewModel;

  const UserActionDetailsBottomSheet(this.actionViewModel) : super(name: AnalyticsScreenNames.userActionDetails);

  @override
  State<UserActionDetailsBottomSheet> createState() => _UserActionDetailsBottomSheetState();
}

class _UserActionDetailsBottomSheetState extends State<UserActionDetailsBottomSheet> {
  late UserActionStatus actionStatus;

  @override
  void initState() {
    super.initState();
    actionStatus = widget.actionViewModel.status;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionDetailsViewModel>(
      converter: (store) => UserActionDetailsViewModel.create(store),
      builder: (context, detailsViewModel) => _build(context, detailsViewModel),
      onWillChange: (previousVm, newVm) => _dismissBottomSheetIfNeeded(context, newVm),
      distinct: true,
    );
  }

  Widget _build(BuildContext context, UserActionDetailsViewModel detailsViewModel) {
    switch (detailsViewModel.displayState) {
      case UserActionDetailsDisplayState.SHOW_CONTENT:
      case UserActionDetailsDisplayState.SHOW_LOADING:
      case UserActionDetailsDisplayState.SHOW_DELETE_ERROR:
        return _bottomSheetContent(context, detailsViewModel);
      case UserActionDetailsDisplayState.SHOW_SUCCESS:
      default:
        return _congratulations(context);
    }
  }

  Widget _congratulations(BuildContext context) {
    _trackSuccessfulUpdate();
    return FractionallySizedBox(
      heightFactor: 0.90,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          userActionBottomSheetHeader(context, title: Strings.actionDetails),
          userActionBottomSheetSeparator(),
          _congratulationsContent(),
          _understood(context),
        ],
      ),
    );
  }

  Widget _congratulationsContent() {
    return Expanded(
        child: Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: Margins.spacing_base),
          Expanded(child: SvgPicture.asset(Drawables.icCongratulations, excludeFromSemantics: true)),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                Strings.congratulationsActionUpdated,
                textAlign: TextAlign.center,
                style: TextStyles.textBaseBold,
              ),
            ),
          ),
          SizedBox(height: Margins.spacing_base),
          Expanded(
            child: Text(
              Strings.conseillerNotifiedActionUpdated,
              textAlign: TextAlign.center,
              style: TextStyles.textBaseRegular,
            ),
          ),
        ],
      )),
    ));
  }

  Widget _understood(BuildContext context) {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: PrimaryActionButton(
        label: Strings.understood,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _update(UserActionStatus newStatus) {
    setState(() {
      actionStatus = newStatus;
    });
  }

  Column _bottomSheetContent(BuildContext context, UserActionDetailsViewModel detailsViewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        userActionBottomSheetHeader(context, title: Strings.actionDetails),
        userActionBottomSheetSeparator(),
        _aboutUserAction(),
        userActionBottomSheetSeparator(),
        _creator(),
        userActionBottomSheetSeparator(),
        _changeStatus(detailsViewModel),
        if (widget.actionViewModel.withDeleteOption) _deleteAction(detailsViewModel)
      ],
    );
  }

  Padding _aboutUserAction() {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_base),
            child: Text(Strings.aboutThisAction, style: TextStyles.textBaseBold),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextWithClickableLinks(
              widget.actionViewModel.title,
              style: TextStyles.textSRegular(),
            ),
          ),
          if (widget.actionViewModel.withSubtitle)
            TextWithClickableLinks(
              widget.actionViewModel.subtitle,
              style: TextStyles.textSRegular(),
            )
          else
            SizedBox(height: Margins.spacing_s)
        ],
      ),
    );
  }

  Padding _creator() {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Row(children: [
        Text(Strings.actionCreatedBy, style: TextStyles.textBaseBold),
        Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.actionViewModel.creator,
                  style: TextStyles.textSBold,
                ))),
      ]),
    );
  }

  Widget _changeStatus(UserActionDetailsViewModel detailsViewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, Margins.spacing_base, Margins.spacing_base),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_base),
            child: Text(Strings.updateStatus, style: TextStyles.textBaseBold),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_base),
            child: UserActionStatusGroup(
              status: actionStatus,
              update: (newStatus) => _update(newStatus),
            ),
          ),
          PrimaryActionButton(
            onPressed: () => {detailsViewModel.onRefreshStatus(widget.actionViewModel.id, actionStatus)},
            label: Strings.refreshActionStatus,
          ),
        ],
      ),
    );
  }

  Widget _deleteAction(UserActionDetailsViewModel detailsViewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, Margins.spacing_base, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryActionButton(
            onPressed: () => _onDeleteAction(detailsViewModel),
            label: Strings.deleteAction,
            textColor: AppColors.warning,
            fontSize: FontSizes.normal,
            backgroundColor: AppColors.warningLighten,
            disabledBackgroundColor: AppColors.warningLight,
            rippleColor: AppColors.warningLight,
            withShadow: false,
          ),
          if (detailsViewModel.displayState == UserActionDetailsDisplayState.SHOW_DELETE_ERROR)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                Strings.deleteActionError,
                textAlign: TextAlign.center,
                style: TextStyles.textSRegular(color: AppColors.warning),
              ),
            ),
        ],
      ),
    );
  }

  void _onDeleteAction(UserActionDetailsViewModel detailsViewModel) {
    if (detailsViewModel.displayState != UserActionDetailsDisplayState.SHOW_LOADING) {
      detailsViewModel.onDelete(widget.actionViewModel.id);
      MatomoTracker.trackScreenWithName(AnalyticsActionNames.deleteUserAction, AnalyticsScreenNames.userActionDetails);
    }
  }

  void _dismissBottomSheetIfNeeded(BuildContext context, UserActionDetailsViewModel viewModel) {
    if (viewModel.displayState == UserActionDetailsDisplayState.TO_DISMISS) {
      Navigator.pop(context);
    } else if (viewModel.displayState == UserActionDetailsDisplayState.TO_DISMISS_AFTER_UPDATE) {
      _trackSuccessfulUpdate();
      Navigator.pop(context);
    } else if (viewModel.displayState == UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION) {
      Navigator.pop(context, UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION);
    }
  }

  void _trackSuccessfulUpdate() {
    MatomoTracker.trackScreenWithName(AnalyticsScreenNames.updateUserAction, AnalyticsScreenNames.userActionDetails);
  }
}
