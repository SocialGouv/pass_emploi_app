import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/secteur_activite.dart';
import 'package:pass_emploi_app/presentation/recherche/evenement_emploi/criteres_recherche_evenement_emploi_contenu_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/recherche/secteur_activite_selector.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/location_autocomplete.dart';

class CriteresRechercheEvenementEmploiContenu extends StatefulWidget {
  final Function(int) onNumberOfCriteresChanged;

  const CriteresRechercheEvenementEmploiContenu({
    required this.onNumberOfCriteresChanged,
  });

  @override
  State<CriteresRechercheEvenementEmploiContenu> createState() => _CriteresRechercheEvenementEmploiContenuState();
}

class _CriteresRechercheEvenementEmploiContenuState extends State<CriteresRechercheEvenementEmploiContenu> {
  bool initialBuild = true;
  Location? _selectedLocation;
  SecteurActivite? _secteurActivite;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CriteresRechercheEvenementEmploiContenuViewModel>(
      onInitialBuild: _onInitialBuild,
      converter: (store) => CriteresRechercheEvenementEmploiContenuViewModel.create(store),
      builder: _builder,
      distinct: true,
    );
  }

  void _onInitialBuild(CriteresRechercheEvenementEmploiContenuViewModel viewModel) {
    if (viewModel.initialLocation != null) _updateCriteresActifsCount();
    initialBuild = false;
  }

  Widget _builder(BuildContext context, CriteresRechercheEvenementEmploiContenuViewModel viewModel) {
    // onInitialBuild is called AFTER the first build, so we need to do it here
    if (initialBuild) {
      _selectedLocation = viewModel.initialLocation;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LocationAutocomplete(
            title: Strings.jobLocationMandatoryTitle,
            hint: Strings.jobEvenementEmploiHint,
            initialValue: _selectedLocation,
            villesOnly: true,
            onLocationSelected: (location) {
              _selectedLocation = location;
              _updateCriteresActifsCount();
            },
          ),
          const SizedBox(height: Margins.spacing_m),
          SecteurActiviteSelector(
            initialValue: _secteurActivite,
            onSecteurActiviteSelected: (secteur) {
              _secteurActivite = secteur;
              _updateCriteresActifsCount();
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

  bool _isSearchButtonEnabled(CriteresRechercheEvenementEmploiContenuViewModel viewModel) =>
      _isFormValid() && !viewModel.displayState.isLoading();

  bool _isFormValid() => _selectedLocation != null;

  void _updateCriteresActifsCount() {
    int criteresActifsCount = 0;
    criteresActifsCount += _secteurActivite != null ? 1 : 0;
    criteresActifsCount += _selectedLocation != null ? 1 : 0;
    widget.onNumberOfCriteresChanged(criteresActifsCount);
  }

  void _search(CriteresRechercheEvenementEmploiContenuViewModel viewModel) {
    if (_selectedLocation == null) return;
    viewModel.onSearchingRequest(_selectedLocation!);
    Keyboard.dismiss(context);
  }
}
