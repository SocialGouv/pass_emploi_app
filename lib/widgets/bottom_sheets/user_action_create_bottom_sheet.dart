import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_create_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

class CreateUserActionBottomSheet extends StatefulWidget {
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

  void _update(UserActionStatus newStatus) {
    setState(() {
      _initialStatus = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.createUserAction,
      child: StoreConnector<AppState, UserActionCreateViewModel>(
        converter: (state) => UserActionCreateViewModel.create(state),
        builder: (context, viewModel) => _buildForm(context, viewModel),
        onWillChange: (previousVm, newVm) => _dismissBottomSheetIfNeeded(context, newVm),
      ),
    );
  }

  Widget _buildForm(BuildContext context, UserActionCreateViewModel viewModel) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: FractionallySizedBox(
        heightFactor: 0.90,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            userActionBottomSheetHeader(context, title: Strings.addAnAction),
            userActionBottomSheetSeparator(),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _actionContentAndComment(viewModel),
                  userActionBottomSheetSeparator(),
                  _defineStatus(viewModel),
                ],
              ),
            ),
            userActionBottomSheetSeparator(),
            _createButton(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _actionContentAndComment(UserActionCreateViewModel viewModel) {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.actionLabel, style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_base),
          _textField(
            isEnabled: viewModel.displayState != UserActionCreateDisplayState.SHOW_LOADING,
            onChanged: (value) => _actionContent = value,
            isMandatory: true,
            mandatoryError: Strings.mandatoryActionLabelError,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: Margins.spacing_base),
          Text(Strings.actionDescription, style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_base),
          _textField(
            isEnabled: viewModel.displayState != UserActionCreateDisplayState.SHOW_LOADING,
            onChanged: (value) => _actionComment = value,
            textInputAction: TextInputAction.done,
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
            borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
          )),
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: textInputAction,
      style: TextStyles.textSBold,
      validator: (value) {
        if (isMandatory && (value == null || value.isEmpty)) return mandatoryError;
        return null;
      },
      onChanged: onChanged,
    );
  }

  Widget _defineStatus(UserActionCreateViewModel viewModel) {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.defineActionStatus, style: TextStyles.textXsRegular()),
          SizedBox(height: Margins.spacing_base),
          UserActionStatusGroup(
            status: _initialStatus,
            update: (wantedStatus) => _update(wantedStatus),
            isCreated: true,
            isEnabled: viewModel.displayState != UserActionCreateDisplayState.SHOW_LOADING,
          ),
        ],
      ),
    );
  }

  Widget _createButton(UserActionCreateViewModel viewModel) {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryActionButton(
            label: Strings.create,
            onPressed: _isLoading(viewModel) && _isFormValid()
                ? () => {viewModel.createUserAction(_actionContent!, _actionComment, _initialStatus)}
                : null,
          ),
          if (viewModel.displayState == UserActionCreateDisplayState.SHOW_ERROR)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Strings.actionCreationError,
                  textAlign: TextAlign.center,
                  style: TextStyles.textSRegular(color: AppColors.warning),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isFormValid() => _formKey.currentState?.validate() == true;

  bool _isLoading(UserActionCreateViewModel viewModel) =>
      viewModel.displayState != UserActionCreateDisplayState.SHOW_LOADING;

  void _dismissBottomSheetIfNeeded(BuildContext context, UserActionCreateViewModel viewModel) {
    if (viewModel.displayState == UserActionCreateDisplayState.TO_DISMISS) {
      Navigator.pop(context);
    }
  }
}
