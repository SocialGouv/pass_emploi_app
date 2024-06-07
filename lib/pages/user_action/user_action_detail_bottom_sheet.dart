import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/user_action/duplicate/duplicate_user_action_page.dart';
import 'package:pass_emploi_app/pages/user_action/update/update_user_action_page.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_bottom_sheet_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheet_button.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';

class UserActionDetailsBottomSheet extends StatelessWidget {
  const UserActionDetailsBottomSheet({required this.source, required this.actionId});
  final UserActionStateSource source;
  final String actionId;

  static Future<void> show(BuildContext context, UserActionStateSource source, String actionId) {
    return showPassEmploiBottomSheet(
      context: context,
      builder: (context) => UserActionDetailsBottomSheet(source: source, actionId: actionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionBottomSheetViewModel>(
        converter: (store) => UserActionBottomSheetViewModel.create(store, source, actionId),
        builder: (context, viewModel) {
          return BottomSheetWrapper(
            title: Strings.userActionBottomSheetTitle,
            heightFactor: 0.6,
            body: SizedBox(
              width: double.infinity,
              child: OverflowBox(
                maxHeight: double.infinity,
                maxWidth: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: Margins.spacing_base),
                      _DuplicateButton(viewModel),
                      if (viewModel.withEditButton) _EditButton(viewModel),
                      if (viewModel.withDeleteButton) _DeleteButton(viewModel),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _DuplicateButton extends StatelessWidget {
  const _DuplicateButton(this.viewModel);

  final UserActionBottomSheetViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return BottomSheetButton(
      icon: AppIcons.content_copy_rounded,
      text: Strings.userActionBottomSheetDuplicate,
      onPressed: () {
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.push(context, DuplicateUserActionPage.route(viewModel.source, viewModel.userActionId));
        }
      },
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton(this.viewModel);
  final UserActionBottomSheetViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return BottomSheetButton(
      icon: AppIcons.edit_rounded,
      text: Strings.userActionBottomSheetEdit,
      withNavigationSuffix: true,
      onPressed: () async {
        Navigator.pop(context);
        Navigator.push(context, UpdateUserActionPage.route(viewModel.source, viewModel.userActionId));
      },
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final UserActionBottomSheetViewModel viewModel;
  const _DeleteButton(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return BottomSheetButton(
      icon: AppIcons.delete,
      text: Strings.userActionBottomSheetDelete,
      color: AppColors.warning,
      onPressed: () {
        viewModel.onDelete();
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
