import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/pages/user_action/create/widgets/user_action_stepper.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_chip.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class CreateUserActionFormStep2 extends StatefulWidget {
  final UserActionReferentielType actionType;
  final CreateUserActionStep2ViewModel viewModel;
  final void Function(CreateActionTitleSource) onTitleChanged;
  final void Function(String) onDescriptionChanged;

  CreateUserActionFormStep2({
    required this.actionType,
    required this.viewModel,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  });

  @override
  State<CreateUserActionFormStep2> createState() => _CreateUserActionFormStep2State();
}

class _CreateUserActionFormStep2State extends State<CreateUserActionFormStep2> {
  late final TextEditingController titleController;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.viewModel.titleSource.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Tracker(
        tracking: AnalyticsScreenNames.createUserActionStep2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Margins.spacing_base),
              Semantics(
                container: true,
                header: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserActionStepperTexts(index: 2),
                    const SizedBox(height: Margins.spacing_s),
                    Text(
                      widget.actionType.label,
                      style: TextStyles.textMBold.copyWith(color: AppColors.contentColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Margins.spacing_m),
              Semantics(
                label: Strings.mandatoryField,
                child: Text(
                  Strings.userActionSubtitleStep2,
                  style: TextStyles.textBaseBold,
                ),
              ),
              const SizedBox(height: Margins.spacing_base),
              _SuggestionTagWrap(
                titleSource: widget.viewModel.titleSource,
                onSelected: (value) => widget.onTitleChanged(value),
                actionType: widget.actionType,
              ),
              if (widget.viewModel.titleSource.isFromUserInput) ...[
                const SizedBox(height: Margins.spacing_m),
                Semantics(
                  label: Strings.mandatoryField,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.userActionTitleTextfieldStep2,
                        style: TextStyles.textBaseBold,
                      ),
                      const SizedBox(height: Margins.spacing_s),
                      BaseTextField(
                        controller: titleController,
                        maxLength: 60,
                        maxLines: 1,
                        onChanged: (value) => widget.onTitleChanged(CreateActionTitleFromUserInput(value)),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionTagWrap extends StatelessWidget {
  final void Function(CreateActionTitleSource) onSelected;
  final CreateActionTitleSource titleSource;
  final UserActionReferentielType actionType;

  const _SuggestionTagWrap({
    required this.titleSource,
    required this.onSelected,
    required this.actionType,
  });

  @override
  Widget build(BuildContext context) {
    final List<UserActionCategory> suggestionList = actionType.suggestionList;
    return Wrap(
      spacing: Margins.spacing_s,
      runSpacing: Margins.spacing_s,
      children: switch (titleSource) {
        CreateActionTitleNotInitialized() => [
            ...suggestionList.map(
              (suggestion) => PassEmploiChip<UserActionCategory>(
                label: suggestion.value,
                value: suggestion,
                isSelected: false,
                onTagSelected: (value) => onSelected(CreateActionTitleFromSuggestions(value)),
                onTagDeleted: () => onSelected(CreateActionTitleNotInitialized()),
              ),
            ),
            PassEmploiChip<String>(
                label: Strings.userActionOther,
                value: '',
                isSelected: false,
                onTagSelected: (value) => onSelected(CreateActionTitleFromUserInput(value)),
                onTagDeleted: () => onSelected(CreateActionTitleNotInitialized()))
          ],
        CreateActionTitleFromSuggestions() => [
            PassEmploiChip<String>(
                label: titleSource.title,
                value: titleSource.title,
                isSelected: true,
                onTagSelected: (value) => onSelected(CreateActionTitleFromUserInput(value)),
                onTagDeleted: () => onSelected(CreateActionTitleNotInitialized()))
          ],
        CreateActionTitleFromUserInput() => [
            PassEmploiChip<String>(
                label: Strings.userActionOther,
                value: '',
                isSelected: true,
                onTagSelected: (value) => onSelected(CreateActionTitleFromUserInput(value)),
                onTagDeleted: () => onSelected(CreateActionTitleNotInitialized()))
          ],
      },
    );
  }
}

class UserActionDescriptionField extends StatelessWidget {
  const UserActionDescriptionField({
    super.key,
    this.descriptionKey,
    required this.descriptionController,
    required this.onDescriptionChanged,
    required this.onClear,
    required this.hintText,
    this.descriptionFocusNode,
    required this.isInvalid,
  });

  final Key? descriptionKey;
  final FocusNode? descriptionFocusNode;
  final TextEditingController descriptionController;
  final void Function(String) onDescriptionChanged;
  final void Function() onClear;
  final String? hintText;
  final bool isInvalid;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.userActionDescriptionTextfieldStep2,
            key: descriptionKey,
            style: TextStyles.textBaseBold,
          ),
          const SizedBox(height: Margins.spacing_s),
          Text(
            Strings.userActionDescriptionDescriptionfieldStep2,
            style: TextStyles.textSRegular(),
          ),
          const SizedBox(height: Margins.spacing_base),
          Stack(
            children: [
              BaseTextField(
                focusNode: descriptionFocusNode,
                controller: descriptionController,
                hintText: hintText,
                maxLines: 5,
                minLines: 1,
                maxLength: 1024,
                onChanged: onDescriptionChanged,
                isInvalid: isInvalid,
              ),
              if (descriptionController.text.isNotEmpty)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    tooltip: Strings.clear,
                    icon: Icon(Icons.clear),
                    onPressed: onClear,
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
