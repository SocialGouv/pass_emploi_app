import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
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
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

class UserActionDetailPage extends StatefulWidget {
  final UserActionViewModel actionViewModel;

  UserActionDetailPage._(this.actionViewModel);

  static MaterialPageRoute<void> materialPageRoute(UserActionViewModel actionViewModel) {
    return MaterialPageRoute(builder: (context) => UserActionDetailPage._(actionViewModel));
  }

  @override
  State<UserActionDetailPage> createState() => _ActionDetailPageState();
}

class _ActionDetailPageState extends State<UserActionDetailPage> {
  late UserActionStatus actionStatus;

  @override
  void initState() {
    super.initState();
    actionStatus = widget.actionViewModel.status;
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.userActionDetails,
      child: Scaffold(
        appBar: passEmploiAppBar(label: Strings.actionDetails, context: context),
        body: StoreConnector<AppState, UserActionDetailsViewModel>(
          onInit: (store) {
            store.dispatch(UserActionNotUpdatingState());
            store.dispatch(UserActionDeleteResetAction());
          },
          converter: (store) => UserActionDetailsViewModel.create(store),
          builder: (context, detailsViewModel) => _build(context, detailsViewModel),
          onWillChange: (previousVm, newVm) => _dismissBottomSheetIfNeeded(context, newVm),
          distinct: true,
        ),
      ),
    );
  }

  void _update(UserActionStatus newStatus) {
    setState(() {
      actionStatus = newStatus;
    });
  }

  Widget _build(BuildContext context, UserActionDetailsViewModel detailsViewModel) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: Margins.spacing_l, left: Margins.spacing_m, right: Margins.spacing_m),
                  child: Text(
                    widget.actionViewModel.title,
                    style: TextStyles.textLBold(),
                  ),
                ),
                SizedBox(height: 24),
                _aboutUserAction(),
                SizedBox(height: 18),
                _Separator(),
                _creator(),
                _Separator(),
                _changeStatus(detailsViewModel),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: PrimaryActionButton(
            onPressed: () => {detailsViewModel.onRefreshStatus(widget.actionViewModel.id, actionStatus)},
            label: Strings.refreshActionStatus,
          ),
        ),
        if (widget.actionViewModel.withDeleteOption) _deleteAction(detailsViewModel)
      ],
    );
  }

  Widget _aboutUserAction() {
    if (widget.actionViewModel.withSubtitle) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
        child: TextWithClickableLinks(
          widget.actionViewModel.subtitle,
          style: TextStyles.textSRegular(),
        ),
      );
    } else {
      return SizedBox(height: Margins.spacing_s);
    }
  }

  Widget _creator() {
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
      padding: const EdgeInsets.fromLTRB(16, 24, Margins.spacing_base, 0),
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
    if (viewModel.displayState == UserActionDetailsDisplayState.SHOW_SUCCESS) {
      showPassEmploiBottomSheet(context: context, builder: _successBottomSheet).then((value) => Navigator.pop(context));
    } else if (viewModel.displayState == UserActionDetailsDisplayState.TO_DISMISS) {
      Navigator.pop(context);
    } else if (viewModel.displayState == UserActionDetailsDisplayState.TO_DISMISS_AFTER_UPDATE) {
      _trackSuccessfulUpdate();
      Navigator.pop(context, UserActionDetailsDisplayState.TO_DISMISS_AFTER_UPDATE);
    } else if (viewModel.displayState == UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION) {
      Navigator.pop(context, UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.deleteActionSuccess)));
    }
  }

  Widget _successBottomSheet(BuildContext context) {
    return _SuccessBottomSheet();
  }

  void _trackSuccessfulUpdate() {
    MatomoTracker.trackScreenWithName(AnalyticsScreenNames.updateUserAction, AnalyticsScreenNames.userActionDetails);
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      child: Container(
        height: 1,
        color: AppColors.primaryLighten,
      ),
    );
  }
}

class _SuccessBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      userActionBottomSheetHeader(context, title: ""),
      SvgPicture.asset(Drawables.icCongratulations),
      Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          Strings.congratulationsActionUpdated,
          style: TextStyles.textBaseBold,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          Strings.conseillerNotifiedActionUpdated,
          style: TextStyles.textBaseRegular,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: PrimaryActionButton(
          label: Strings.understood,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ]);
  }
}
