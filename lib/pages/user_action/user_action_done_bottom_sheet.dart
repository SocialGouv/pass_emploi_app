import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_done_bottom_sheet_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker_suggestions.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class UserActionDoneBottomSheet extends StatelessWidget {
  const UserActionDoneBottomSheet({required this.source, required this.actionId});

  final UserActionStateSource source;
  final String actionId;

  static Future<bool?> show(BuildContext context, UserActionStateSource source, String actionId) {
    return showPassEmploiBottomSheet<bool?>(
      context: context,
      builder: (context) => UserActionDoneBottomSheet(source: source, actionId: actionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionDoneBottomSheetViewModel>(
        converter: (store) => UserActionDoneBottomSheetViewModel.create(store, source, actionId),
        onDispose: (store) => store.dispatch(UserActionUpdateResetAction()),
        onInit: (store) => store.dispatch(UserActionUpdateResetAction()),
        builder: (context, viewModel) {
          return BottomSheetWrapper(
            title: viewModel.displayState == DisplayState.EMPTY ? Strings.userActionDoneBottomSheetTitle : "",
            maxHeightFactor: 0.6,
            body: SingleChildScrollView(
              child: _Body(viewModel),
            ),
          );
        });
  }
}

class _Body extends StatelessWidget {
  const _Body(this.viewModel);
  final UserActionDoneBottomSheetViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AnimationDurations.fast,
      child: switch (viewModel.displayState) {
        DisplayState.CONTENT => _Success(),
        DisplayState.FAILURE => _Error(),
        DisplayState.LOADING || DisplayState.EMPTY => Stack(
            children: [
              Opacity(
                opacity: viewModel.displayState == DisplayState.LOADING ? 0.5 : 1,
                child: IgnorePointer(
                  ignoring: viewModel.displayState == DisplayState.LOADING,
                  child: _Form(viewModel),
                ),
              ),
              if (viewModel.displayState == DisplayState.LOADING) const Center(child: CircularProgressIndicator()),
            ],
          ),
      },
    );
  }
}

class _Form extends StatefulWidget {
  const _Form(this.viewModel);
  final UserActionDoneBottomSheetViewModel viewModel;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  DateInputSource date = DateNotInitialized();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: Margins.spacing_base),
        DatePickerSuggestions(
          title: Strings.dateShortMandatory,
          isForPastSuggestions: true,
          onDateChanged: (selectedDate) {
            setState(() {
              date = selectedDate;
            });
          },
          dateSource: date,
        ),
        SizedBox(height: Margins.spacing_base),
        PrimaryActionButton(
          label: Strings.jeValide,
          onPressed: date.isValid ? () => widget.viewModel.onActionDone(date.selectedDate) : null,
        ),
        const SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}

class _Success extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: Margins.spacing_xl),
        Center(
          child: SizedBox(
            height: 130,
            width: 130,
            child: Illustration.green(AppIcons.check_rounded),
          ),
        ),
        SizedBox(height: Margins.spacing_xl),
        Text(
          Strings.felicitations,
          textAlign: TextAlign.center,
          style: TextStyles.textMBold,
        ),
        SizedBox(height: Margins.spacing_base),
        Text(
          Strings.updateActionConfirmation,
          textAlign: TextAlign.center,
          style: TextStyles.textBaseRegular,
        ),
        SizedBox(height: Margins.spacing_l),
        PrimaryActionButton(label: Strings.understood, onPressed: () => Navigator.pop(context, true)),
        const SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}

class _Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Retry(
      Strings.miscellaneousErrorRetry,
      () => Navigator.pop(context, false),
      buttonLabel: Strings.close,
    );
  }
}
