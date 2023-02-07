import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/service_civique/criteres_recherche_service_civique_contenu_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/location_autocomplete.dart';

class CriteresRechercheServiceCiviqueContenu extends StatefulWidget {
  final Function(int) onNumberOfCriteresChanged;

  const CriteresRechercheServiceCiviqueContenu({
    required this.onNumberOfCriteresChanged,
  });

  @override
  State<CriteresRechercheServiceCiviqueContenu> createState() => _CriteresRechercheServiceCiviqueContenuState();
}

class _CriteresRechercheServiceCiviqueContenuState extends State<CriteresRechercheServiceCiviqueContenu> {
  LocationViewModel? _selectedLocationViewModel;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CriteresRechercheServiceCiviqueContenuViewModel>(
      converter: (store) => CriteresRechercheServiceCiviqueContenuViewModel.create(store),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, CriteresRechercheServiceCiviqueContenuViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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

  void _updateCriteresActifsCount() {
    int criteresActifsCount = 0;
    criteresActifsCount += _selectedLocationViewModel != null ? 1 : 0;
    widget.onNumberOfCriteresChanged(criteresActifsCount);
  }

  void _search(CriteresRechercheServiceCiviqueContenuViewModel viewModel) {
    viewModel.onSearchingRequest(_selectedLocationViewModel?.location);
    Keyboard.dismiss(context);
  }
}
