import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action_add_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

import 'bottom_sheets.dart';

class UserActionAddBottomSheet extends StatefulWidget {
  UserActionAddBottomSheet() : super();

  @override
  State<UserActionAddBottomSheet> createState() => _UserActionAddBottomSheetState();
}

class _UserActionAddBottomSheetState extends State<UserActionAddBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _actionContent;
  String? _actionComment;
  late UserActionStatus _initialStatus;

  @override
  void initState() {
    super.initState();
    _initialStatus = UserActionStatus.NOT_STARTED;
  }

  _update(UserActionStatus newStatus) {
    setState(() {
      _initialStatus = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionAddViewModel>(
      converter: (state) => UserActionAddViewModel.create(state),
      builder: (context, viewModel) => Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            userActionBottomSheetHeader(context, title: Strings.addAnAction),
            userActionBottomSheetSeparator(),
            _actionContentAndComment(),
            userActionBottomSheetSeparator(),
            _defineStatus(),
            userActionBottomSheetSeparator(),
            _createButton(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _actionContentAndComment() {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.actionLabel, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          SizedBox(height: 16),
          _textField(
            onChanged: (value) => _actionContent = value,
            isMandatory: true,
            mandatoryError: Strings.mandatoryActionLabelError,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16),
          Text(Strings.actionDescription, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          SizedBox(height: 16),
          _textField(
            onChanged: (value) => _actionComment = value,
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }

  TextFormField _textField({
    required ValueChanged<String>? onChanged,
    bool isMandatory = false,
    String? mandatoryError,
    TextInputAction? textInputAction,
  }) {
    return TextFormField(
      minLines: 3,
      maxLines: 3,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
          )),
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: textInputAction,
      style: TextStyles.textSmRegular(),
      validator: (value) {
        if (isMandatory && (value == null || value.isEmpty)) return mandatoryError;
        return null;
      },
      onChanged: onChanged,
    );
  }

  Widget _defineStatus() {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.defineActionStatus, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          SizedBox(height: 16),
          UserActionStatusGroup(status: _initialStatus, update: (wantedStatus) => _update(wantedStatus)),
        ],
      ),
    );
  }

  Widget _createButton(UserActionAddViewModel viewModel) {
    return Padding(
      padding: userActionBottomSheetContentPadding().add(const EdgeInsets.only(top: 64)),
      child: userActionBottomSheetActionButton(
        label: Strings.create,
        onPressed: () => {viewModel.createUserAction(_actionContent, _actionComment, _initialStatus)},
      ),
    );
  }
}
