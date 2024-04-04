import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/presentation/recherche/immersion/criteres_recherche_immersion_contenu_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/a11y/mandatory_fields_label.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/location_autocomplete.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/metier_autocomplete.dart';

class CriteresRechercheImmersionContenu extends StatefulWidget {
  final Function(int) onNumberOfCriteresChanged;

  const CriteresRechercheImmersionContenu({
    required this.onNumberOfCriteresChanged,
  });

  @override
  State<CriteresRechercheImmersionContenu> createState() => _CriteresRechercheImmersionContenuState();
}

class _CriteresRechercheImmersionContenuState extends State<CriteresRechercheImmersionContenu> {
  bool initialBuild = true;
  Location? _selectedLocation;
  Metier? _selectedMetier;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CriteresRechercheImmersionContenuViewModel>(
      onInitialBuild: _onInitialBuild,
      converter: (store) => CriteresRechercheImmersionContenuViewModel.create(store),
      builder: _builder,
      distinct: true,
    );
  }

  void _onInitialBuild(CriteresRechercheImmersionContenuViewModel viewModel) {
    if (viewModel.initialLocation != null || viewModel.initialMetier != null) _updateCriteresActifsCount();
    initialBuild = false;
  }

  Widget _builder(BuildContext context, CriteresRechercheImmersionContenuViewModel viewModel) {
    // onInitialBuild is called AFTER the first build, so we need to do it here
    if (initialBuild) {
      _selectedLocation = viewModel.initialLocation;
      _selectedMetier = viewModel.initialMetier;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MandatoryFieldsLabel.all(),
          const SizedBox(height: Margins.spacing_base),
          MetierAutocomplete(
            title: Strings.metierLabel,
            hint: Strings.metierImmersionHint,
            initialValue: viewModel.initialMetier,
            onMetierSelected: (metier) {
              _selectedMetier = metier;
              _updateCriteresActifsCount();
            },
          ),
          SizedBox(height: Margins.spacing_m),
          LocationAutocomplete(
            title: Strings.jobLocationTitle,
            hint: Strings.jobLocationImmersionHint,
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
            onPressed: _isSearchButtonEnabled(viewModel) ? () => _search(viewModel) : null,
          ),
          const SizedBox(height: Margins.spacing_m),
        ],
      ),
    );
  }

  bool _isSearchButtonEnabled(CriteresRechercheImmersionContenuViewModel viewModel) =>
      _isFormValid() && !viewModel.displayState.isLoading();

  bool _isFormValid() => _selectedLocation != null && _selectedMetier != null;

  void _updateCriteresActifsCount() {
    int criteresActifsCount = 0;
    criteresActifsCount += _selectedLocation != null ? 1 : 0;
    criteresActifsCount += _selectedMetier != null ? 1 : 0;
    widget.onNumberOfCriteresChanged(criteresActifsCount);
  }

  void _search(CriteresRechercheImmersionContenuViewModel viewModel) {
    if (_selectedMetier == null || _selectedLocation == null) return;
    viewModel.onSearchingRequest(_selectedMetier!, _selectedLocation!);
  }
}
