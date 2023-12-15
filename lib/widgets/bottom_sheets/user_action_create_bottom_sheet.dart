import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_create_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/confetti_wrapper.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

// TODO: FIXME: Delete this file and all Strings
class CreateUserActionBottomSheet extends StatefulWidget {
  static MaterialPageRoute<UserActionCreateDisplayState?> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CreateUserActionBottomSheet());
  }

  static void displaySnackBarOnResult(
    BuildContext context,
    UserActionCreateDisplayState? result,
    UserActionStateSource source,
    Function() onResult,
  ) {
    if (result is DismissWithSuccess) {
      _showSnackBarWithDetail(context, source, result.userActionCreatedId);
      onResult();
    } else if (result is DismissWithFailure) {
      _showSnackBarForOfflineCreation(context);
      onResult();
    }
  }

  static void _showSnackBarWithDetail(
    BuildContext context,
    UserActionStateSource source,
    String userActionId,
  ) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.createActionEventCategory,
      action: AnalyticsEventNames.createActionDisplaySnackBarAction,
    );
    showSnackBarWithSuccess(
      context,
      Strings.createActionSuccess,
      () {
        PassEmploiMatomoTracker.instance.trackEvent(
          eventCategory: AnalyticsEventNames.createActionEventCategory,
          action: AnalyticsEventNames.createActionClickOnSnackBarAction,
        );
        Navigator.push(context, UserActionDetailPage.materialPageRoute(userActionId, source));
      },
    );
  }

  static void _showSnackBarForOfflineCreation(BuildContext context) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.createActionEventCategory,
      action: AnalyticsEventNames.createActionOfflineAction,
    );
    showSnackBarWithSuccess(context, Strings.createActionPostponed);
  }

  @override
  State<CreateUserActionBottomSheet> createState() => _CreateUserActionBottomSheetState();
}

class _CreateUserActionBottomSheetState extends State<CreateUserActionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.createUserAction,
      child: StoreConnector<AppState, UserActionCreateViewModel>(
        converter: (state) => UserActionCreateViewModel.create(state),
        builder: (context, viewModel) => _CreateActionForm(viewModel),
        onWillChange: (previousVm, newVm) => _dismissBottomSheetIfNeeded(context, newVm),
      ),
    );
  }

  void _dismissBottomSheetIfNeeded(BuildContext context, UserActionCreateViewModel viewModel) {
    final displayState = viewModel.displayState;
    if (displayState is DismissWithSuccess || displayState is DismissWithFailure) Navigator.pop(context, displayState);
  }
}

class _CreateActionForm extends StatefulWidget {
  final UserActionCreateViewModel viewModel;

  const _CreateActionForm(this.viewModel);

  @override
  State<_CreateActionForm> createState() => __CreateActionFormState();
}

class __CreateActionFormState extends State<_CreateActionForm> {
  late ActionFormState state;

  @override
  void initState() {
    state = ActionFormState(onSubmit: (request) => widget.viewModel.createUserAction(request))
      ..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return ConfettiWrapper(builder: (context, confettiController) {
      return Scaffold(
        appBar: SecondaryAppBar(title: Strings.addAnAction),
        floatingActionButton: _createButton(viewModel),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Padding(
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
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    ..._actionContentAndComment(viewModel),
                    SizedBox(height: Margins.spacing_xl),
                    _DateEcheance(
                      dateEcheance: state.dateEcheance,
                      onDateEcheanceChange: state.dateEcheanceChanged,
                      validator: state.showDateEcheanceError ? Strings.mandatoryDateEcheanceError : null,
                    ),
                    SizedBox(height: Margins.spacing_xl),
                    _Rappel(
                      value: state.withRappel,
                      isActive: viewModel.isRappelActive(state.dateEcheance),
                      onChanged: state.rappelChanged,
                    ),
                    SizedBox(height: Margins.spacing_xl),
                    SepLine(0, 0),
                    _defineStatus(viewModel, () => confettiController.play()),
                    SizedBox(height: Margins.spacing_xl),
                    SizedBox(height: Margins.spacing_xl),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _createButton(UserActionCreateViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryActionButton(
            label: Strings.create,
            onPressed: _isNotLoading(viewModel) ? () => state.submitForm() : null,
          ),
        ],
      ),
    );
  }

  Widget _defineStatus(UserActionCreateViewModel viewModel, VoidCallback onActionDone) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.defineActionStatus, style: TextStyles.textXsRegular()),
        SizedBox(height: Margins.spacing_base),
        UserActionStatusGroup(
          onActionDone: onActionDone,
          status: state.status,
          update: state.statusChanged,
          isCreated: true,
          isEnabled: viewModel.displayState is! DisplayLoading,
        ),
      ],
    );
  }

  bool _isNotLoading(UserActionCreateViewModel viewModel) => viewModel.displayState is! DisplayLoading;

  List<Widget> _actionContentAndComment(UserActionCreateViewModel viewModel) {
    return [
      Semantics(
        label: Strings.actionLabel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(child: Text(Strings.actionLabel, style: TextStyles.textBaseBold)),
            SizedBox(height: Margins.spacing_base),
            BaseTextField(
              enabled: viewModel.displayState is! DisplayLoading,
              onChanged: state.intituleChanged,
              errorText: state.showIntituleError ? Strings.mandatoryActionLabelError : null,
              maxLines: 3,
              minLines: 3,
            ),
          ],
        ),
      ),
      SizedBox(height: Margins.spacing_base),
      Text(Strings.actionDescription, style: TextStyles.textBaseBold),
      SizedBox(height: Margins.spacing_base),
      BaseTextField(
        enabled: viewModel.displayState is! DisplayLoading,
        errorText: null,
        onChanged: state.descriptionChanged,
        maxLines: 3,
        minLines: 3,
      ),
    ];
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
  final String? validator;

  const _DateEcheance({required this.dateEcheance, required this.onDateEcheanceChange, required this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("*${Strings.selectEcheance}", style: TextStyles.textBaseMedium),
        SizedBox(height: Margins.spacing_s),
        DatePicker(
          onValueChange: (date) => onDateEcheanceChange(date),
          initialDateValue: dateEcheance,
          isActiveDate: true,
          errorText: validator,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text(Strings.rappelSwitch, style: textStyle)),
        SizedBox(width: Margins.spacing_m),
        Switch(
          value: isActive && value,
          onChanged: isActive ? onChanged : null,
        ),
        SizedBox(width: Margins.spacing_xs),
        Text(isActive && value ? Strings.yes : Strings.no, style: textStyle),
      ],
    );
  }
}

class ActionFormState extends ChangeNotifier {
  final void Function(UserActionCreateRequest) onSubmit;
  String intitule;
  String description;
  bool withRappel;
  DateTime? dateEcheance;
  UserActionStatus status;
  bool showIntituleError;
  bool showDateEcheanceError;

  ActionFormState({required this.onSubmit})
      : intitule = "",
        description = "",
        withRappel = false,
        dateEcheance = null,
        status = UserActionStatus.NOT_STARTED,
        showIntituleError = false,
        showDateEcheanceError = false;

  void intituleChanged(String newIntitule) {
    intitule = newIntitule;
    showIntituleError = false;
    notifyListeners();
  }

  void descriptionChanged(String newDescription) {
    description = newDescription;
    notifyListeners();
  }

  void rappelChanged(bool newWithRappel) {
    withRappel = newWithRappel;
    notifyListeners();
  }

  void dateEcheanceChanged(DateTime newDateEcheance) {
    dateEcheance = newDateEcheance;
    showDateEcheanceError = false;
    notifyListeners();
  }

  void statusChanged(UserActionStatus newStatus) {
    status = newStatus;
    notifyListeners();
  }

  void submit() {
    showIntituleError = true;
    showDateEcheanceError = true;
    notifyListeners();
  }

  bool isIntituleValid() => intitule.isNotEmpty;

  bool isDateEcheanceValid() => dateEcheance != null;

  bool isFormValid() => isIntituleValid() && isDateEcheanceValid();

  void submitForm() {
    if (!isIntituleValid()) showIntituleError = true;
    if (!isDateEcheanceValid()) showDateEcheanceError = true;

    if (isFormValid()) {
      onSubmit(UserActionCreateRequest(intitule, description, dateEcheance!, withRappel, status));
    }

    notifyListeners();
  }
}
