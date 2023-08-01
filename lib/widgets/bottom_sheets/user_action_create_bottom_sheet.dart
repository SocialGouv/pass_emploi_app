import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_create_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

class CreateUserActionBottomSheet extends StatefulWidget {
  static MaterialPageRoute<String?> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CreateUserActionBottomSheet());
  }

  @override
  State<CreateUserActionBottomSheet> createState() => _CreateUserActionBottomSheetState();
}

class _CreateUserActionBottomSheetState extends State<CreateUserActionBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late UserActionStatus _initialStatus;
  String? _actionContent;
  String? _actionComment;
  bool _rappel = false;
  DateTime? _dateEcheance;

  @override
  void initState() {
    super.initState();
    _initialStatus = UserActionStatus.NOT_STARTED;
  }

  void _updateUserActionStatus(UserActionStatus newStatus) {
    setState(() => _initialStatus = newStatus);
  }

  void _updateContent(String content) {
    setState(() => _actionContent = content);
  }

  void _updateComment(String comment) {
    setState(() => _actionComment = comment);
  }

  void _updateDateEcheance(DateTime date) {
    setState(() => _dateEcheance = date);
  }

  void _updateRappel(bool rappel) {
    setState(() => _rappel = rappel);
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
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.addAnAction),
      floatingActionButton: _createButton(viewModel),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Mandatory(),
              SizedBox(height: Margins.spacing_base),
              SepLine(0, 0),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ..._actionContentAndComment(viewModel),
                    SizedBox(height: Margins.spacing_xl),
                    _DateEcheance(
                      dateEcheance: _dateEcheance,
                      onDateEcheanceChange: _updateDateEcheance,
                    ),
                    SizedBox(height: Margins.spacing_xl),
                    _Rappel(
                      value: _rappel,
                      isActive: viewModel.isRappelActive(_dateEcheance),
                      onChanged: _updateRappel,
                    ),
                    SizedBox(height: Margins.spacing_xl),
                    SepLine(0, 0),
                    _defineStatus(viewModel),
                    SizedBox(height: Margins.spacing_xl),
                    SizedBox(height: Margins.spacing_xl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _actionContentAndComment(UserActionCreateViewModel viewModel) {
    return [
      Semantics(
        label: Strings.actionLabel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(child: Text(Strings.actionLabel, style: TextStyles.textBaseBold)),
            SizedBox(height: Margins.spacing_base),
            _textField(
              isEnabled: viewModel.displayState is! DisplayLoading,
              onChanged: _updateContent,
              isMandatory: true,
              mandatoryError: Strings.mandatoryActionLabelError,
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
      SizedBox(height: Margins.spacing_base),
      Text(Strings.actionDescription, style: TextStyles.textBaseBold),
      SizedBox(height: Margins.spacing_base),
      _textField(
        isEnabled: viewModel.displayState is! DisplayLoading,
        onChanged: _updateComment,
        textInputAction: TextInputAction.done,
      ),
    ];
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
          borderRadius: BorderRadius.circular(Dimens.radius_base),
          borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
        ),
      ),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.defineActionStatus, style: TextStyles.textXsRegular()),
        SizedBox(height: Margins.spacing_base),
        UserActionStatusGroup(
          status: _initialStatus,
          update: (wantedStatus) => _updateUserActionStatus(wantedStatus),
          isCreated: true,
          isEnabled: viewModel.displayState is! DisplayLoading,
        ),
      ],
    );
  }

  Widget _createButton(UserActionCreateViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryActionButton(
            label: Strings.create,
            onPressed: _isLoading(viewModel) && _isFormValid()
                ? () => {
                      viewModel.createUserAction(
                        UserActionCreateRequest(
                          _actionContent!,
                          _actionComment,
                          _dateEcheance!,
                          _rappel,
                          _initialStatus,
                        ),
                      )
                    }
                : null,
          ),
          if (viewModel.displayState is DisplayError)
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

  bool _isFormValid() => _formKey.currentState?.validate() == true && _dateEcheance != null;

  bool _isLoading(UserActionCreateViewModel viewModel) => viewModel.displayState is! DisplayLoading;

  void _dismissBottomSheetIfNeeded(BuildContext context, UserActionCreateViewModel viewModel) {
    final displayState = viewModel.displayState;
    if (displayState is Dismiss) Navigator.pop(context, displayState.userActionCreatedId);
  }
}

class _Mandatory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(Strings.mandatoryFields, style: TextStyles.textSRegular());
  }
}

class _DateEcheance extends StatelessWidget {
  final DateTime? dateEcheance;
  final Function(DateTime) onDateEcheanceChange;

  const _DateEcheance({required this.dateEcheance, required this.onDateEcheanceChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.selectEcheance, style: TextStyles.textBaseMedium),
        SizedBox(height: Margins.spacing_s),
        DatePicker(
          onValueChange: (date) => onDateEcheanceChange(date),
          initialDateValue: dateEcheance,
          isActiveDate: true,
        ),
      ],
    );
  }
}

class _Rappel extends StatelessWidget {
  final bool value;
  final bool isActive;
  final ValueChanged<bool> onChanged;

  const _Rappel({required this.value, required this.isActive, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textStyle = isActive ? TextStyles.textBaseRegular : TextStyles.textBaseRegularWithColor(AppColors.disabled);
    return Row(
      children: [
        Expanded(child: Text(Strings.rappelSwitch, style: textStyle)),
        SizedBox(width: Margins.spacing_m),
        Switch(
          value: isActive && value,
          onChanged: isActive ? onChanged : null,
          activeColor: AppColors.primary,
          inactiveTrackColor: AppColors.disabled,
        ),
        Text(isActive && value ? Strings.yes : Strings.no, style: textStyle),
      ],
    );
  }
}
