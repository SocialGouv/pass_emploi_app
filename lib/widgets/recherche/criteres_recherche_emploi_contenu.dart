import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/criteres_cherche_contenu_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/location_autocomplete.dart';

class CriteresRechercheEmploiContenu extends StatelessWidget {
  final Function(String) onKeywordChanged;
  final Function(LocationViewModel? locationViewModel) onSelectLocationViewModel;
  final String? Function() getPreviouslySelectedTitle;
  final Function() onRechercheButtonPressed;

  const CriteresRechercheEmploiContenu({
    required this.onKeywordChanged,
    required this.onSelectLocationViewModel,
    required this.getPreviouslySelectedTitle,
    required this.onRechercheButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CriteresRechercheContenuViewModel>(
      converter: (store) => CriteresRechercheContenuViewModel.create(store),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, CriteresRechercheContenuViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.keyWordsTitle, style: TextStyles.textBaseBold),
          Text(Strings.keyWordsTextHint, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
          SizedBox(height: Margins.spacing_base),
          _keywordTextFormField(),
          const SizedBox(height: Margins.spacing_m),
          Text(Strings.jobLocationTitle, style: TextStyles.textBaseBold),
          Text(Strings.jobLocationHint, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
          SizedBox(height: Margins.spacing_base),
          LocationAutocomplete(
            onInputLocation: (newLocationQuery) => viewModel.onInputLocation(newLocationQuery),
            onSelectLocationViewModel: onSelectLocationViewModel,
            locationViewModels: viewModel.locations,
            hint: Strings.jobLocationHint,
            getPreviouslySelectedTitle: getPreviouslySelectedTitle,
            formKey: null,
            validator: (value) => null,
          ),
          const SizedBox(height: Margins.spacing_m),
          if (viewModel.displayState.isFailure()) ErrorText(Strings.genericError),
          PrimaryActionButton(
            label: Strings.searchButton,
            onPressed: viewModel.displayState.isLoading() ? null : onRechercheButtonPressed,
          ),
          const SizedBox(height: Margins.spacing_m),
        ],
      ),
    );
  }

  TextFormField _keywordTextFormField() {
    return TextFormField(
      style: TextStyles.textBaseBold,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.done,
      decoration: _inputDecoration(),
      onChanged: onKeywordChanged,
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(left: 24, top: 18, bottom: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.primary, width: 1.0),
      ),
    );
  }
}
