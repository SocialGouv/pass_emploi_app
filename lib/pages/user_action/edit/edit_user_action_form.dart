import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_step1.dart';
import 'package:pass_emploi_app/pages/user_action/edit/edit_user_action_form_change_notifier.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/mandatory_fields_label.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker_suggestions.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class EditUserActionFormDto {
  final DateTime date;
  final String title;
  final String description;
  final UserActionReferentielType? type;

  EditUserActionFormDto({
    required this.date,
    required this.title,
    required this.description,
    required this.type,
  });

  EditUserActionFormChangeNotifier toChangeNotifier(bool requireUpdate) {
    return EditUserActionFormChangeNotifier(
      date: date,
      title: title,
      description: description,
      type: type,
      requireUpdate: requireUpdate,
    );
  }

  static EditUserActionFormDto fromChangeNotifier(EditUserActionFormChangeNotifier changeNotifier) {
    return EditUserActionFormDto(
      date: changeNotifier.dateInputSource.selectedDate,
      title: changeNotifier.title,
      description: changeNotifier.description,
      type: changeNotifier.type,
    );
  }
}

class EditUserActionForm extends StatefulWidget {
  const EditUserActionForm({
    required this.actionDto,
    required this.requireUpdate,
    required this.onSaved,
    required this.confirmationLabel,
  });

  final EditUserActionFormDto actionDto;
  final bool requireUpdate;
  final String confirmationLabel;
  final void Function(EditUserActionFormDto) onSaved;

  @override
  State<EditUserActionForm> createState() => _EditUserActionFormState();
}

class _EditUserActionFormState extends State<EditUserActionForm> {
  late final EditUserActionFormChangeNotifier _changeNotifier;

  @override
  void initState() {
    super.initState();
    _changeNotifier = widget.actionDto.toChangeNotifier(widget.requireUpdate);
    _changeNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MandatoryFieldsLabel.some(),
          SizedBox(height: Margins.spacing_m),
          DatePickerSuggestions(
            title: Strings.datePickerTitleMandatory,
            onDateChanged: (dateSource) => _changeNotifier.updateDate(dateSource),
            dateSource: _changeNotifier.dateInputSource,
          ),
          const SizedBox(height: Margins.spacing_m),
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
          const SizedBox(height: Margins.spacing_m),
          Divider(height: 1, color: AppColors.primaryLighten),
          const SizedBox(height: Margins.spacing_base),
          SizedBox(
            width: double.infinity,
            child: _SaveButton(
              label: widget.confirmationLabel,
              isActive: _changeNotifier.canSave(),
              onSave: () => widget.onSaved(EditUserActionFormDto.fromChangeNotifier(_changeNotifier)),
            ),
          ),
          const SizedBox(height: Margins.spacing_huge * 4),
        ],
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector(this.changeNotifier);

  final EditUserActionFormChangeNotifier changeNotifier;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Row(
        children: [
          Text(changeNotifier.type?.label ?? Strings.userActionNoCategory, style: TextStyles.textBaseRegular),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: ActionCategorySelector(
            onActionSelected: (type) => Navigator.of(context).pop(type),
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.isActive,
    required this.onSave,
    required this.label,
  });

  final bool isActive;
  final String label;
  final void Function() onSave;

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      label: label,
      onPressed: isActive ? onSave : null,
    );
  }
}
