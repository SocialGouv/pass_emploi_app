import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/emploi/criteres_recherche_emploi_contenu_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/location_autocomplete.dart';

class CriteresRechercheEmploiContenu extends StatefulWidget {
  final bool onlyAlternance;
  final Function(int) onNumberOfCriteresChanged;

  const CriteresRechercheEmploiContenu({
    required this.onlyAlternance,
    required this.onNumberOfCriteresChanged,
  });

  @override
  State<CriteresRechercheEmploiContenu> createState() => _CriteresRechercheEmploiContenuState();
}

class _CriteresRechercheEmploiContenuState extends State<CriteresRechercheEmploiContenu> {
  LocationViewModel? _selectedLocationViewModel;
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CriteresRechercheEmploiContenuViewModel>(
      converter: (store) => CriteresRechercheEmploiContenuViewModel.create(store),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, CriteresRechercheEmploiContenuViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.keywordTitle, style: TextStyles.textBaseBold),
          Text(Strings.keywordHint, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
          SizedBox(height: Margins.spacing_base),
          _keywordTextFormField(),
          const SizedBox(height: Margins.spacing_m),
          Text(Strings.jobLocationTitle, style: TextStyles.textBaseBold),
          Text(Strings.jobLocationHint, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
          SizedBox(height: Margins.spacing_base),
          LocationAutocomplete(
            onInputLocation: (newLocationQuery) => viewModel.onInputLocation(newLocationQuery),
            onSelectLocationViewModel: (locationViewModel) {
              _selectedLocationViewModel = locationViewModel;
              _updateCriteresActifsCount();
            },
            locationViewModels: viewModel.locations,
            hint: Strings.jobLocationHint,
            getPreviouslySelectedTitle: () => _selectedLocationViewModel?.title,
            formKey: null,
            validator: (value) => null,
          ),
          const SizedBox(height: Margins.spacing_m),
          if (viewModel.displayState.isFailure()) ErrorText(Strings.genericError),
          PrimaryActionButton(
            label: Strings.searchButton,
            onPressed: viewModel.displayState.isLoading() ? null : () => _search(viewModel),
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
      onChanged: (keyword) {
        _keyword = keyword;
        _updateCriteresActifsCount();
      },
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

  void _updateCriteresActifsCount() {
    int criteresActifsCount = 0;
    criteresActifsCount += _keyword.isNotEmpty ? 1 : 0;
    criteresActifsCount += _selectedLocationViewModel != null ? 1 : 0;
    widget.onNumberOfCriteresChanged(criteresActifsCount);
  }

  void _search(CriteresRechercheEmploiContenuViewModel viewModel) {
    viewModel.onSearchingRequest(_keyword, _selectedLocationViewModel?.location, widget.onlyAlternance);
    Keyboard.dismiss(context);
  }
}
