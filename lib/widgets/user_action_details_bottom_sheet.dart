import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
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
    return _bottomSheetContent(context);
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
              Navigator.pop(context, true),
            },
            label: Strings.refreshActionStatus,
          ),
        ],
      ),
    );
  }
}
