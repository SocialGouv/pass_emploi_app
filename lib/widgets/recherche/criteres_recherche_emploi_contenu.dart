import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/presentation/recherche/emploi/criteres_recherche_emploi_contenu_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/keyword_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/location_autocomplete.dart';

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
  Location? _selectedLocation;
  String? _keyword;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CriteresRechercheEmploiContenuViewModel>(
      converter: (store) => CriteresRechercheEmploiContenuViewModel.create(store),
      builder: _builder,
      distinct: true,
      onDispose: (store) => store.dispatch(SearchLocationResetAction()),
    );
  }

  Widget _builder(BuildContext context, CriteresRechercheEmploiContenuViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KeywordTextFormField(
            title: Strings.keywordTitle,
            hint: Strings.keywordHint,
            onKeywordSelected: (keyword) {
              _keyword = keyword;
              _updateCriteresActifsCount();
            },
          ),
          const SizedBox(height: Margins.spacing_m),
          LocationAutocomplete(
            title: Strings.jobLocationTitle,
            hint: Strings.jobLocationHint,
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
    criteresActifsCount += _keyword?.isNotEmpty == true ? 1 : 0;
    criteresActifsCount += _selectedLocation != null ? 1 : 0;
    widget.onNumberOfCriteresChanged(criteresActifsCount);
  }

  void _search(CriteresRechercheEmploiContenuViewModel viewModel) {
    viewModel.onSearchingRequest(_keyword ?? '', _selectedLocation, widget.onlyAlternance);
    Keyboard.dismiss(context);
  }
}
