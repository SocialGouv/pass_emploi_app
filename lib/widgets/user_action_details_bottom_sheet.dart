import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

class UserActionDetailsBottomSheet extends StatelessWidget {
  final UserActionViewModel viewModel;

  const UserActionDetailsBottomSheet(this.viewModel) : super();

  @override
  Widget build(BuildContext context) {
    return _bottomSheetContent(context);
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
              viewModel.content,
              style: TextStyles.textMdMedium,
            ),
          ),
          ..._insertCommentIfPresent(viewModel),
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
            child: UserActionStatusGroup(isInitiallyDone: viewModel.isDone),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: TextStyles.textSmMedium(),
              backgroundColor: AppColors.nightBlue,
              shape: StadiumBorder(),
            ),
            onPressed: () => print("toto"),
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
