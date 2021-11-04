import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/create_user_action_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

import 'bottom_sheets.dart';

class CreateUserActionBottomSheet extends StatefulWidget {
  CreateUserActionBottomSheet() : super();

  @override
  State<CreateUserActionBottomSheet> createState() => _CreateUserActionBottomSheetState();
}

class _CreateUserActionBottomSheetState extends State<CreateUserActionBottomSheet> {
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
    return StoreConnector<AppState, CreateUserActionViewModel>(
      converter: (state) => CreateUserActionViewModel.create(state),
      builder: (context, viewModel) => _build(context, viewModel),
      onWillChange: (previousVm, newVm) => _dismissBottomSheetIfNeeded(context, newVm),
    );
  }

  _build(BuildContext context, CreateUserActionViewModel viewModel) {
    if (viewModel.displayState != CreateUserActionDisplayState.TO_DISMISS) {
      return _buildForm(context, viewModel);
    }
  }

  Form _buildForm(BuildContext context, CreateUserActionViewModel viewModel) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          userActionBottomSheetHeader(context, title: Strings.addAnAction),
          userActionBottomSheetSeparator(),
          _actionContentAndComment(viewModel),
          userActionBottomSheetSeparator(),
          _defineStatus(),
          userActionBottomSheetSeparator(),
          _createButton(viewModel),
        ],
      ),
    );
  }

  Widget _actionContentAndComment(CreateUserActionViewModel viewModel) {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.actionLabel, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          SizedBox(height: 16),
          _textField(
            isEnabled: viewModel.displayState != CreateUserActionDisplayState.SHOW_LOADING,
            onChanged: (value) => _actionContent = value,
            isMandatory: true,
            mandatoryError: Strings.mandatoryActionLabelError,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16),
          Text(Strings.actionDescription, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          SizedBox(height: 16),
          _textField(
            isEnabled: viewModel.displayState != CreateUserActionDisplayState.SHOW_LOADING,
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
    required bool isEnabled,
  }) {
    return TextFormField(
      enabled: isEnabled,
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

  Widget _createButton(CreateUserActionViewModel viewModel) {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          userActionBottomSheetActionButton(
            label: Strings.create,
            onPressed: _isLoading(viewModel) && _isFormValid()
                ? () => {viewModel.createUserAction(_actionContent!, _actionComment, _initialStatus)}
                : null,
          ),
          if (viewModel.displayState == CreateUserActionDisplayState.SHOW_ERROR)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Strings.actionCreationError,
                  textAlign: TextAlign.center,
                  style: TextStyles.textSmRegular(color: AppColors.errorRed),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isFormValid() => _formKey.currentState?.validate() == true;

  bool _isLoading(CreateUserActionViewModel viewModel) => viewModel.displayState != CreateUserActionDisplayState.SHOW_LOADING;

  _dismissBottomSheetIfNeeded(BuildContext context, CreateUserActionViewModel viewModel) {
    if (viewModel.displayState == CreateUserActionDisplayState.TO_DISMISS) {
      Navigator.pop(context);
    }
  }
}
