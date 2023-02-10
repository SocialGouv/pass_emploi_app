import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/immersion/criteres_recherche_immersion_contenu_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/location_autocomplete.dart';
import 'package:pass_emploi_app/widgets/metier_autocomplete.dart';

class CriteresRechercheImmersionContenu extends StatefulWidget {
  final Function(int) onNumberOfCriteresChanged;

  const CriteresRechercheImmersionContenu({
    required this.onNumberOfCriteresChanged,
  });

  @override
  State<CriteresRechercheImmersionContenu> createState() => _CriteresRechercheImmersionContenuState();
}

class _CriteresRechercheImmersionContenuState extends State<CriteresRechercheImmersionContenu> {
  LocationViewModel? _selectedLocationViewModel;
  Metier? _selectedMetier;
  final _metierFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CriteresRechercheImmersionContenuViewModel>(
      converter: (store) => CriteresRechercheImmersionContenuViewModel.create(store),
      builder: _builder,
      distinct: true,
      onDispose: (store) {
        store.dispatch(SearchLocationResetAction());
        store.dispatch(SearchMetierResetAction());
      },
    );
  }

  Widget _builder(BuildContext context, CriteresRechercheImmersionContenuViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.metierCompulsoryLabel, style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_base),
          MetierAutocomplete(
            onInputMetier: (newMetierQuery) => viewModel.onInputMetier(newMetierQuery),
            metiers: viewModel.metiers,
            onSelectMetier: (selectedMetier) {
              _selectedMetier = selectedMetier;
              _updateCriteresActifsCount();
            },
            formKey: _metierFormKey,
            getPreviouslySelectedTitle: () => _selectedMetier?.libelle,
            validator: (value) {
              if (value == null || value.isEmpty || _selectedMetier == null) {
                return Strings.immersionMetierError;
              }
              return null;
            },
          ),
          SizedBox(height: Margins.spacing_m),
          Text(Strings.villeCompulsoryLabel, style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_base),
          LocationAutocomplete(
            onInputLocation: (newLocationQuery) => viewModel.onInputLocation(newLocationQuery),
            onSelectLocationViewModel: (locationViewModel) {
              _selectedLocationViewModel = locationViewModel;
              _updateCriteresActifsCount();
            },
            locationViewModels: viewModel.locations,
            hint: Strings.immersionFieldHint,
            getPreviouslySelectedTitle: () => _selectedLocationViewModel?.title,
            formKey: _locationFormKey,
            validator: (value) {
              if (value == null || value.isEmpty || _selectedLocationViewModel == null) {
                return Strings.immersionVilleError;
              }
              return null;
            },
          ),
          const SizedBox(height: Margins.spacing_m),
          if (viewModel.displayState.isFailure()) ErrorText(Strings.genericError),
          PrimaryActionButton(
            label: Strings.searchButton,
            onPressed: _isSearchButtonEnabled(viewModel) ? () => _search(viewModel) : null,
          ),
          const SizedBox(height: Margins.spacing_m),
        ],
      ),
    );
  }

  bool _isSearchButtonEnabled(CriteresRechercheImmersionContenuViewModel viewModel) =>
      _isFormValid() && !viewModel.displayState.isLoading();

  bool _isFormValid() => _isMetierFormValid() && _locationFormKey.currentState?.validate() == true;

  bool _isMetierFormValid() => _selectedMetier != null && _metierFormKey.currentState?.validate() == true;

  void _updateCriteresActifsCount() {
    int criteresActifsCount = 0;
    criteresActifsCount += _selectedLocationViewModel != null ? 1 : 0;
    criteresActifsCount += _selectedMetier != null ? 1 : 0;
    widget.onNumberOfCriteresChanged(criteresActifsCount);
  }

  void _search(CriteresRechercheImmersionContenuViewModel viewModel) {
    if (_selectedMetier == null || _selectedLocationViewModel == null) return;
    viewModel.onSearchingRequest(_selectedMetier!, _selectedLocationViewModel!.location);
    Keyboard.dismiss(context);
  }
}
