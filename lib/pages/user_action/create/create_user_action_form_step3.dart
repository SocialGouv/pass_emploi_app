import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_step2.dart';
import 'package:pass_emploi_app/pages/user_action/create/widgets/user_action_stepper.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/a11y/mandatory_fields_label.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker_suggestions.dart';

class CreateUserActionFormStep3 extends StatefulWidget {
  const CreateUserActionFormStep3({
    required this.actionType,
    required this.titleSource,
    required this.viewModel,
    required this.onDateChanged,
    required this.onDescriptionChanged,
    required this.onDelete,
    required this.onAddDuplicatedUserAction,
  });

  final UserActionReferentielType actionType;
  final CreateActionTitleSource titleSource;
  final CreateUserActionStep3ViewModel viewModel;
  final void Function(String id, DateInputSource dateSource) onDateChanged;
  final void Function(String id, String description) onDescriptionChanged;
  final void Function(String id) onDelete;
  final void Function() onAddDuplicatedUserAction;

  @override
  State<CreateUserActionFormStep3> createState() => _CreateUserActionFormStep3State();
}

class _CreateUserActionFormStep3State extends State<CreateUserActionFormStep3> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Tracker(
        tracking: AnalyticsScreenNames.createUserActionStep3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Margins.spacing_s),
              Semantics(
                container: true,
                header: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserActionStepperTexts(index: 3),
                    const SizedBox(height: Margins.spacing_s),
                    Text(
                      widget.actionType.label,
                      style: TextStyles.textMBold.copyWith(color: AppColors.contentColor),
                    ),
                    Text(
                      widget.titleSource.title,
                      style: TextStyles.textBaseMedium.copyWith(color: AppColors.contentColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Margins.spacing_m),
              MandatoryFieldsLabel.all(),
              const SizedBox(height: Margins.spacing_m),
              Text(
                widget.titleSource.allowBatchCreate ? Strings.selectMultipleActions : Strings.selectOneAction,
                style: TextStyles.textBaseBold.copyWith(color: AppColors.contentColor),
              ),
              if (widget.viewModel.errorsVisible && !widget.viewModel.isValid) ...[
                const SizedBox(height: Margins.spacing_base),
                _ErrorItem(
                  icon: AppIcons.error_rounded,
                  text: Strings.fillAllFields,
                ),
              ],
              const SizedBox(height: Margins.spacing_m),
              _DuplicateUserActionList(
                viewModel: widget.viewModel,
                onDateChanged: widget.onDateChanged,
                onDescriptionChanged: widget.onDescriptionChanged,
                onDelete: widget.onDelete,
                titleSource: widget.titleSource,
                scrollController: _scrollController,
              ),
              if (widget.titleSource.allowBatchCreate)
                SecondaryButton(
                  icon: AppIcons.add,
                  label: Strings.duplicateAction,
                  onPressed: () {
                    widget.viewModel.canCreateMoreDuplicatedUserActions
                        ? widget.onAddDuplicatedUserAction.call()
                        : null;
                    PassEmploiMatomoTracker.instance.trackEvent(
                      eventCategory: AnalyticsEventNames.createActionv2EventCategory,
                      action: AnalyticsEventNames.createActionResultMultipleAction,
                    );
                  },
                  isEnabled: widget.viewModel.canCreateMoreDuplicatedUserActions,
                ),
              const SizedBox(height: Margins.spacing_xx_huge * 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _DuplicateUserActionList extends StatelessWidget {
  const _DuplicateUserActionList({
    required this.viewModel,
    required this.onDateChanged,
    required this.onDescriptionChanged,
    required this.onDelete,
    required this.titleSource,
    required this.scrollController,
  });

  final CreateUserActionStep3ViewModel viewModel;
  final void Function(String id, DateInputSource dateSource) onDateChanged;
  final void Function(String id, String description) onDescriptionChanged;
  final void Function(String id) onDelete;
  final CreateActionTitleSource titleSource;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.duplicatedUserActions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Margins.spacing_m),
          child: _DuplicateUserActionItem(
            key: ValueKey(viewModel.duplicatedUserActions[index].id),
            duplicatedUserAction: viewModel.duplicatedUserActions[index],
            onDateChanged: (dateSource) => onDateChanged(viewModel.duplicatedUserActions[index].id, dateSource),
            onDescriptionChanged: (description) =>
                onDescriptionChanged(viewModel.duplicatedUserActions[index].id, description),
            onDelete: () => onDelete(viewModel.duplicatedUserActions[index].id),
            index: index,
            titleSource: titleSource,
            errorsVisible: viewModel.errorsVisible,
            scrollController: scrollController,
          ),
        );
      },
    );
  }
}

class _DuplicateUserActionItem extends StatefulWidget {
  const _DuplicateUserActionItem({
    super.key,
    required this.duplicatedUserAction,
    required this.onDateChanged,
    required this.onDescriptionChanged,
    required this.onDelete,
    required this.index,
    required this.titleSource,
    required this.errorsVisible,
    required this.scrollController,
  });

  final DuplicatedUserAction duplicatedUserAction;
  final void Function(DateInputSource dateSource) onDateChanged;
  final void Function(String description) onDescriptionChanged;
  final void Function() onDelete;
  final int index;
  final CreateActionTitleSource titleSource;
  final bool errorsVisible;
  final ScrollController scrollController;

  @override
  State<_DuplicateUserActionItem> createState() => _DuplicateUserActionItemState();
}

class _DuplicateUserActionItemState extends State<_DuplicateUserActionItem> {
  late final TextEditingController descriptionController;
  late final FocusNode descriptionFocusNode;
  final GlobalKey _descriptionFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(text: widget.duplicatedUserAction.description);
    descriptionFocusNode = FocusNode();
    descriptionFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    descriptionFocusNode.removeListener(_onFocusChange);
    descriptionController.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (descriptionFocusNode.hasFocus) {
      _scrollToDescriptionField();
    }
  }

  void _scrollToDescriptionField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _descriptionFieldKey.currentContext;
      if (context != null && widget.scrollController.hasClients) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final scrollOffset = widget.scrollController.offset;
        final screenHeight = MediaQuery.of(context).size.height;

        // Calculer la position cible pour centrer le champ à l'écran
        final targetOffset = position.dy + scrollOffset - (screenHeight / 2) + (renderBox.size.height / 2);

        widget.scrollController.animateTo(
          targetOffset.clamp(0.0, widget.scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final showDescriptionError = widget.errorsVisible && !widget.duplicatedUserAction.isDescriptionValid;
    final showDateError = widget.errorsVisible && !widget.duplicatedUserAction.isDateValid;
    return Stack(
      children: [
        CardContainer(
          child: Column(
            children: [
              DatePickerSuggestions(
                title: Strings.datePickerTitle,
                dateSource: widget.duplicatedUserAction.dateSource,
                onDateChanged: widget.onDateChanged,
                isInvalid: showDateError,
              ),
              if (showDateError) ...[
                const SizedBox(height: Margins.spacing_s),
                _ErrorItem(
                  icon: AppIcons.error_rounded,
                  text: Strings.dateMandatory,
                ),
              ],
              AnimatedCrossFade(
                crossFadeState: widget.duplicatedUserAction.dateSource.isNone
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: AnimationDurations.fast,
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: [
                    const SizedBox(height: Margins.spacing_base),
                    UserActionDescriptionField(
                      key: _descriptionFieldKey,
                      descriptionController: descriptionController,
                      onDescriptionChanged: (value) => widget.onDescriptionChanged(value),
                      onClear: () {
                        descriptionController.clear();
                        widget.onDescriptionChanged("");
                      },
                      hintText: Strings.exampleHint + widget.titleSource.descriptionHint,
                      descriptionFocusNode: descriptionFocusNode,
                      isInvalid: showDescriptionError,
                    ),
                    if (showDescriptionError) ...[
                      const SizedBox(height: Margins.spacing_s),
                      _ErrorItem(
                        icon: AppIcons.error_rounded,
                        text: Strings.descriptionMandatory,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.index > 0)
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              tooltip: Strings.clear,
              icon: Icon(Icons.clear),
              onPressed: widget.onDelete,
            ),
          )
      ],
    );
  }
}

class _ErrorItem extends StatelessWidget {
  const _ErrorItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.warning),
        const SizedBox(width: Margins.spacing_s),
        Text(text, style: TextStyles.textBaseRegular.copyWith(color: AppColors.warning)),
      ],
    );
  }
}
