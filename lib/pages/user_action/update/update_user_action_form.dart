import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_step1.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';
import 'package:pass_emploi_app/presentation/user_action/update_form/update_user_action_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker_suggestions.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
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

class _Body extends StatelessWidget {
  const _Body(this.viewModel);

  final UpdateUserActionViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.updateUserActionPageTitle),
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
                onDateChanged: (dateSource) => print(dateSource),
                dateSource: DateFromPicker(viewModel.date),
              ),
              Text(Strings.updateUserActionTitle, style: TextStyles.textBaseBold),
              const SizedBox(height: Margins.spacing_s),
              BaseTextField(
                initialValue: viewModel.title,
                onChanged: (title) => print(title),
              ),
              const SizedBox(height: Margins.spacing_m),
              Text(Strings.updateUserActionDescriptionTitle, style: TextStyles.textBaseBold),
              Text(Strings.updateUserActionDescriptionSubtitle, style: TextStyles.textXsRegular()),
              const SizedBox(height: Margins.spacing_s),
              BaseTextField(
                initialValue: viewModel.subtitle,
                onChanged: (subtitle) => print(subtitle),
                maxLines: 5,
              ),
              const SizedBox(height: Margins.spacing_m),
              Text(Strings.updateUserActionCategory, style: TextStyles.textBaseBold),
              BaseCard(
                title: 'choisis un truc',
                onTap: () => Navigator.of(context)
                    .push(_CategorySelectionPage.route())
                    .then((type) => print('@@@@@@@@@@@ type $type')),
              )
            ],
          ),
        ),
      ),
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
      body: CreateUserActionFormStep1(onActionTypeSelected: (type) => Navigator.of(context).pop(type)),
    );
  }
}
