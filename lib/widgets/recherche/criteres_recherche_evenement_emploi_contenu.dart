import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_emploi/secteur_activite.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/recherche/evenement_emploi/criteres_recherche_evenement_emploi_contenu_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
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
  SecteurActivite? _secteurSecteurActivite;

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
    if (viewModel.initialLocation != null || viewModel.initialSecteurActivite != null) _updateCriteresActifsCount();
    initialBuild = false;
  }

  Widget _builder(BuildContext context, CriteresRechercheEvenementEmploiContenuViewModel viewModel) {
    // onInitialBuild is called AFTER the first build, so we need to do it here
    if (initialBuild) {
      _selectedLocation = viewModel.initialLocation;
      _secteurSecteurActivite = viewModel.initialSecteurActivite;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.mandatoryFields, style: TextStyles.textSRegular()),
          const SizedBox(height: Margins.spacing_base),
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
            initialValue: _secteurSecteurActivite,
            onSecteurActiviteSelected: (secteur) {
              _secteurSecteurActivite = secteur;
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
    criteresActifsCount += _secteurSecteurActivite != null ? 1 : 0;
    criteresActifsCount += _selectedLocation != null ? 1 : 0;
    widget.onNumberOfCriteresChanged(criteresActifsCount);
  }

  void _search(CriteresRechercheEvenementEmploiContenuViewModel viewModel) {
    if (_selectedLocation == null) return;
    viewModel.onSearchingRequest(EvenementEmploiCriteresRecherche(
      location: _selectedLocation!,
      secteurActivite: _secteurSecteurActivite,
    ));
  }
}
