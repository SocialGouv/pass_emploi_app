import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_step1.dart';
import 'package:pass_emploi_app/pages/user_action/update/update_user_action_form_change_notifier.dart';
import 'package:pass_emploi_app/presentation/user_action/update_form/update_user_action_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker_suggestions.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class UpdateUserActionForm extends StatelessWidget {
  final UserActionStateSource source;
  final String userActionId;

  const UpdateUserActionForm({super.key, required this.source, required this.userActionId});

  static MaterialPageRoute<void> route(UserActionStateSource source, String userActionId) {
    return MaterialPageRoute<void>(
      builder: (_) => UpdateUserActionForm(source: source, userActionId: userActionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UpdateUserActionViewModel>(
      converter: (store) => UpdateUserActionViewModel.create(store, source, userActionId),
      builder: (context, viewModel) => _Body(viewModel),
      distinct: true,
    );
  }
}

class _Body extends StatefulWidget {
  const _Body(this.viewModel);

  final UpdateUserActionViewModel viewModel;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final UpdateUserActionFormChangeNotifier _changeNotifier;

  @override
  void initState() {
    super.initState();
    _changeNotifier = UpdateUserActionFormChangeNotifier(
      date: widget.viewModel.date,
      title: widget.viewModel.title,
      description: widget.viewModel.description,
      type: widget.viewModel.type,
    );
    _changeNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: SecondaryAppBar(title: Strings.updateUserActionPageTitle),
          floatingActionButton: _Buttons(
            changeNotifier: _changeNotifier,
            onSave: () => widget.viewModel.save(
              _changeNotifier.dateInputSource.selectedDate,
              _changeNotifier.title,
              _changeNotifier.description,
              _changeNotifier.type,
            ),
            onDelete: () => widget.viewModel.delete(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.mandatoryFields,
                    style: TextStyles.textSRegular(),
                  ),
                  SizedBox(height: Margins.spacing_m),
                  DatePickerSuggestions(
                    onDateChanged: (dateSource) => _changeNotifier.updateDate(dateSource),
                    dateSource: _changeNotifier.dateInputSource,
                  ),
                  Text(Strings.updateUserActionTitle, style: TextStyles.textBaseBold),
                  const SizedBox(height: Margins.spacing_s),
                  BaseTextField(
                    initialValue: _changeNotifier.title,
                    onChanged: _changeNotifier.updateTitle,
                  ),
                  const SizedBox(height: Margins.spacing_m),
                  Text(Strings.updateUserActionDescriptionTitle, style: TextStyles.textBaseBold),
                  Text(Strings.updateUserActionDescriptionSubtitle, style: TextStyles.textXsRegular()),
                  const SizedBox(height: Margins.spacing_s),
                  BaseTextField(
                    initialValue: _changeNotifier.description,
                    onChanged: _changeNotifier.updateDescription,
                    maxLines: 5,
                  ),
                  const SizedBox(height: Margins.spacing_m),
                  Text(Strings.updateUserActionCategory, style: TextStyles.textBaseBold),
                  const SizedBox(height: Margins.spacing_s),
                  _CategorySelector(_changeNotifier),
                  const SizedBox(height: Margins.spacing_huge * 4),
                ],
              ),
            ),
          ),
        ),
        if (widget.viewModel.showLoading)
          ColoredBox(
            color: Colors.white.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector(this.changeNotifier);

  final UpdateUserActionFormChangeNotifier changeNotifier;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Row(
        children: [
          Text(changeNotifier.type?.label ?? Strings.userActionNoCategory),
          Expanded(child: PressedTip(Strings.updateUserActionCategoryPressedTip)),
        ],
      ),
      onTap: () => Navigator.of(context).push(_CategorySelectionPage.route()).then(changeNotifier.updateType),
    );
  }
}

class _CategorySelectionPage extends StatelessWidget {
  static MaterialPageRoute<UserActionReferentielType> route() {
    return MaterialPageRoute<UserActionReferentielType>(builder: (_) => _CategorySelectionPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.updateUserActionCategory),
      body: SingleChildScrollView(
        child: ActionCategorySelector(
          onActionSelected: (type) => Navigator.of(context).pop(type),
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({required this.changeNotifier, required this.onSave, required this.onDelete});

  final UpdateUserActionFormChangeNotifier changeNotifier;
  final void Function() onSave;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryActionButton(
            label: Strings.updateUserActionSaveButton,
            onPressed: changeNotifier.hasChanged ? onSave : null,
          ),
          const SizedBox(height: Margins.spacing_s),
          SecondaryButton(
            label: Strings.deleteAction,
            backgroundColor: Colors.white,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
