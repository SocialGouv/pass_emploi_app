import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action_details_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

import 'bottom_sheets.dart';

class UserActionDetailsBottomSheet extends StatefulWidget {
  final UserActionListPageViewModel listViewModel;
  final UserActionViewModel viewModel;

  const UserActionDetailsBottomSheet(this.listViewModel, this.viewModel) : super();

  @override
  State<UserActionDetailsBottomSheet> createState() => _UserActionDetailsBottomSheetState();
}

class _UserActionDetailsBottomSheetState extends State<UserActionDetailsBottomSheet> {
  late UserActionStatus actionStatus;

  @override
  void initState() {
    super.initState();
    actionStatus = widget.viewModel.status;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionDetailsViewModel>(
      converter: (store) => UserActionDetailsViewModel.create(store),
      builder: (context, viewModel) => _build(context, viewModel),
      onWillChange: (previousVm, newVm) => _dismissBottomSheetIfNeeded(context, newVm),
      distinct: true,
    );
  }

  _build(BuildContext context, UserActionDetailsViewModel viewModel) {
    switch (viewModel.displayState) {
      case UserActionDetailsState.SHOW_CONTENT:
        return _bottomSheetContent(context);
      case UserActionDetailsState.SHOW_SUCCESS:
        return _congratulations(context);
      case UserActionDetailsState.TO_DISMISS:
        break;
    }
  }

  FractionallySizedBox _congratulations(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.85,
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
          SvgPicture.asset("assets/ic_congratulations.svg", excludeFromSemantics: true),
          SizedBox(height: 64),
          Text(Strings.congratulationsActionUpdated, textAlign: TextAlign.center, style: TextStyles.textSmMedium()),
          SizedBox(height: 16),
          Text(Strings.conseillerNotifiedActionUpdated, textAlign: TextAlign.center, style: TextStyles.textSmRegular()),
        ],
      )),
    ));
  }

  Widget _understood(BuildContext context) {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: userActionBottomSheetActionButton(
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

  Column _bottomSheetContent(BuildContext context) {
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
        _changeStatus()
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
              widget.viewModel.content,
              style: TextStyles.textMdMedium,
            ),
          ),
          ..._insertCommentIfPresent(),
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
                  widget.viewModel.creator,
                  style: TextStyles.textSmMedium(),
                ))),
      ]),
    );
  }

  List<Text> _insertCommentIfPresent() {
    if (widget.viewModel.withComment) {
      return [
        Text(
          widget.viewModel.comment,
          style: TextStyles.textSmRegular(color: AppColors.bluePurple),
        )
      ];
    } else {
      return [];
    }
  }

  Widget _changeStatus() {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
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
          userActionBottomSheetActionButton(
            onPressed: () => {
              widget.listViewModel.onRefreshStatus(widget.viewModel.id, actionStatus),
            },
            label: Strings.refreshActionStatus,
          ),
        ],
      ),
    );
  }

  _dismissBottomSheetIfNeeded(BuildContext context, UserActionDetailsViewModel viewModel) {
    if (viewModel.displayState == UserActionDetailsState.TO_DISMISS) {
      Navigator.pop(context);
    }
  }
}
