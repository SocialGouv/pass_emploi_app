import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/user_action_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

class UserActionDetailsBottomSheet extends StatefulWidget {
  final UserActionListPageViewModel listViewModel;
  final UserActionViewModel viewModel;

  const UserActionDetailsBottomSheet(this.listViewModel, this.viewModel) : super();

  @override
  State<UserActionDetailsBottomSheet> createState() => _UserActionDetailsBottomSheetState();
}

class _UserActionDetailsBottomSheetState extends State<UserActionDetailsBottomSheet> {
  late bool isActionDone;

  @override
  void initState() {
    super.initState();
    isActionDone = widget.viewModel.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return _bottomSheetContent(context);
  }

  _update(bool isNowDone) {
    setState(() {
      isActionDone = isNowDone;
    });
  }

  Column _bottomSheetContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _bottomSheetHeader(context),
        _bottomSheetSeparator(),
        _aboutUserAction(),
        _bottomSheetSeparator(),
        _changeStatus()
      ],
    );
  }

  Divider _bottomSheetSeparator() => Divider(thickness: 1, color: AppColors.bluePurpleAlpha20);

  EdgeInsets _bottomSheetContentPadding() => const EdgeInsets.fromLTRB(16, 24, 16, 24);

  Padding _aboutUserAction() {
    return Padding(
      padding: _bottomSheetContentPadding(),
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
          ..._insertCommentIfPresent(widget.viewModel),
        ],
      ),
    );
  }

  List<Text> _insertCommentIfPresent(UserActionViewModel viewModel) {
    if (viewModel.withComment) {
      return [
        Text(
          viewModel.comment,
          style: TextStyles.textSmRegular(color: AppColors.bluePurple),
        )
      ];
    } else {
      return [];
    }
  }

  Padding _bottomSheetHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Text(Strings.actionDetails, style: TextStyles.textMdMedium),
          Positioned(
            right: 8,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              iconSize: 48,
              onPressed: () => Navigator.pop(context),
              tooltip: Strings.close,
              icon: SvgPicture.asset("assets/ic_close.svg"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _changeStatus() {
    return Padding(
      padding: _bottomSheetContentPadding(),
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
              isDone: isActionDone,
              update: (bool isNowDone) => _update(isNowDone),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: TextStyles.textSmMedium(),
              backgroundColor: AppColors.nightBlue,
              shape: StadiumBorder(),
            ),
            onPressed: () =>
            {
              widget.listViewModel.onRefreshStatus(widget.viewModel.id, isActionDone),
              Navigator.pop(context, true),
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(Strings.refreshActionStatus),
            ),
          )
        ],
      ),
    );
  }
}
