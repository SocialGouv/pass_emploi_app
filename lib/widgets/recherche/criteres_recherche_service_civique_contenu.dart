import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/recherche/service_civique/criteres_recherche_service_civique_contenu_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/location_autocomplete.dart';

class CriteresRechercheServiceCiviqueContenu extends StatefulWidget {
  final Function(int) onNumberOfCriteresChanged;

  const CriteresRechercheServiceCiviqueContenu({
    required this.onNumberOfCriteresChanged,
  });

  @override
  State<CriteresRechercheServiceCiviqueContenu> createState() => _CriteresRechercheServiceCiviqueContenuState();
}

class _CriteresRechercheServiceCiviqueContenuState extends State<CriteresRechercheServiceCiviqueContenu> {
  bool initialBuild = true;
  Location? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CriteresRechercheServiceCiviqueContenuViewModel>(
      converter: (store) => CriteresRechercheServiceCiviqueContenuViewModel.create(store),
      onInitialBuild: _onInitialBuild,
      builder: _builder,
      distinct: true,
    );
  }

  void _onInitialBuild(CriteresRechercheServiceCiviqueContenuViewModel viewModel) {
    if (viewModel.initialLocation != null) _updateCriteresActifsCount();
    initialBuild = false;
  }

  Widget _builder(BuildContext context, CriteresRechercheServiceCiviqueContenuViewModel viewModel) {
    // onInitialBuild is called AFTER the first build, so we need to do it here
    if (initialBuild) _selectedLocation = viewModel.initialLocation;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LocationAutocomplete(
            title: Strings.locationTitle,
            hint: Strings.jobLocationServiceCiviqueHint,
            villesOnly: true,
            initialValue: viewModel.initialLocation,
            onLocationSelected: (location) {
              _selectedLocation = location;
              _updateCriteresActifsCount();
            },
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

  void _updateCriteresActifsCount() {
    int criteresActifsCount = 0;
    criteresActifsCount += _selectedLocation != null ? 1 : 0;
    widget.onNumberOfCriteresChanged(criteresActifsCount);
  }

  void _search(CriteresRechercheServiceCiviqueContenuViewModel viewModel) {
    viewModel.onSearchingRequest(_selectedLocation);
  }
}
