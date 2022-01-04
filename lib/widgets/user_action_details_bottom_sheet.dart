import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action_details_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

import 'bottom_sheets.dart';
import 'primary_action_button.dart';

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

  _build(BuildContext context, UserActionDetailsViewModel detailsViewModel) {
    switch (detailsViewModel.displayState) {
      case UserActionDetailsDisplayState.SHOW_CONTENT:
      case UserActionDetailsDisplayState.SHOW_LOADING:
      case UserActionDetailsDisplayState.SHOW_DELETE_ERROR:
        return _bottomSheetContent(context, detailsViewModel);
      case UserActionDetailsDisplayState.SHOW_SUCCESS:
        return _congratulations(context);
      case UserActionDetailsDisplayState.TO_DISMISS:
      case UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION:
        break;
    }
  }

  Widget _congratulations(BuildContext context) {
    MatomoTracker.trackEvent(AnalyticsScreenNames.updateUserAction, 'Click');
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
          SizedBox(height: 16),
          Expanded(child: SvgPicture.asset(Drawables.icCongratulations, excludeFromSemantics: true)),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                Strings.congratulationsActionUpdated,
                textAlign: TextAlign.center,
                style: TextStyles.textSmMedium(),
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Container(
              child: Text(
                Strings.conseillerNotifiedActionUpdated,
                textAlign: TextAlign.center,
                style: TextStyles.textSmRegular(),
              ),
            ),
          ),
        ],
      )),
    ));
  }

  Widget _understood(BuildContext context) {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: PrimaryActionButton.simple(
        label: Strings.understood,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  _update(UserActionStatus newStatus) {
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
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(Strings.aboutThisAction, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.actionViewModel.content,
              style: TextStyles.textMdMedium,
            ),
          ),
          if (widget.actionViewModel.withComment)
            Text(
              widget.actionViewModel.comment,
              style: TextStyles.textSmRegular(color: AppColors.bluePurple),
            )
          else
            SizedBox(height: 8)
        ],
      ),
    );
  }

  Padding _creator() {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Row(children: [
        Text(Strings.actionCreatedBy, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
        Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.actionViewModel.creator,
                  style: TextStyles.textSmMedium(),
                ))),
      ]),
    );
  }

  Widget _changeStatus(UserActionDetailsViewModel detailsViewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(Strings.updateStatus, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: UserActionStatusGroup(
              status: actionStatus,
              update: (newStatus) => _update(newStatus),
            ),
          ),
          PrimaryActionButton.simple(
            onPressed: () => {detailsViewModel.onRefreshStatus(widget.actionViewModel.id, actionStatus)},
            label: Strings.refreshActionStatus,
          ),
        ],
      ),
    );
  }

  Widget _deleteAction(UserActionDetailsViewModel detailsViewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryActionButton.simple(
            onPressed: detailsViewModel.displayState == UserActionDetailsDisplayState.SHOW_LOADING
                ? null
                : () => detailsViewModel.onDelete(widget.actionViewModel.id),
            label: Strings.deleteAction,
            textColor: AppColors.franceRed,
            backgroundColor: AppColors.franceRedAlpha05,
            disabledBackgroundColor: AppColors.redGrey,
            rippleColor: AppColors.redGrey,
          ),
          if (detailsViewModel.displayState == UserActionDetailsDisplayState.SHOW_DELETE_ERROR)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                Strings.deleteActionError,
                textAlign: TextAlign.center,
                style: TextStyles.textSmRegular(color: AppColors.errorRed),
              ),
            ),
        ],
      ),
    );
  }

  _dismissBottomSheetIfNeeded(BuildContext context, UserActionDetailsViewModel viewModel) {
    if (viewModel.displayState == UserActionDetailsDisplayState.TO_DISMISS)
      Navigator.pop(context);
    else if (viewModel.displayState == UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION)
      Navigator.pop(context, UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION);
  }
}
