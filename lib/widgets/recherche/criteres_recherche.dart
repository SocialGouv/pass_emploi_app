import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_critereres_cherche_contenu_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_critereres_cherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/location_autocomplete.dart';

class CriteresRecherche extends StatefulWidget {
  @override
  State<CriteresRecherche> createState() => _CriteresRechercheState();
}

class _CriteresRechercheState extends State<CriteresRecherche> {
  LocationViewModel? _selectedLocationViewModel;
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCriteresRechercheViewModel>(
      converter: (store) => BlocCriteresRechercheViewModel.create(store),
      builder: (context, viewModel) {
        return Column(
          children: [
            Material(
              elevation: 16, //TODO Real box shadow ?
              borderRadius: BorderRadius.circular(Dimens.radius_s),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.radius_s),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    key: UniqueKey(),
                    // required to force rebuild with new vm.isOpen value
                    collapsedBackgroundColor: AppColors.primary,
                    collapsedIconColor: Colors.white,
                    iconColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    collapsedTextColor: Colors.white,
                    title: _CriteresRechercheBandeau(),
                    initiallyExpanded: viewModel.isOpen,
                    children: [
                      _CriteresRechercheContenu(
                        onKeywordChanged: (keyword) => _keyword = keyword,
                        onSelectLocationViewModel: (locationVM) => _selectedLocationViewModel = locationVM,
                        getPreviouslySelectedTitle: () => _selectedLocationViewModel?.title,
                        onRechercheButtonPressed: () {
                          // TODO: 1353 - only alternanc
                          viewModel.onSearchingRequest(_keyword, _selectedLocationViewModel?.location, false);
                          Keyboard.dismiss(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      distinct: true,
    );
  }
}

class _CriteresRechercheBandeau extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      // TODO: 1353 MAJ des critères
      "(0) critères actifs",
      // TODO: 1353 Créer un bon TextStyle à part
      style: TextStyle(
        fontFamily: 'Marianne',
        fontSize: FontSizes.medium,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CriteresRechercheContenu extends StatelessWidget {
  final Function(String) onKeywordChanged;
  final Function(LocationViewModel? locationViewModel) onSelectLocationViewModel;
  final String? Function() getPreviouslySelectedTitle;
  final Function() onRechercheButtonPressed;

  const _CriteresRechercheContenu({
    required this.onKeywordChanged,
    required this.onSelectLocationViewModel,
    required this.getPreviouslySelectedTitle,
    required this.onRechercheButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCriteresRechercheContenuViewModel>(
      converter: (store) => BlocCriteresRechercheContenuViewModel.create(store),
      builder: (context, viewModel) {
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
              PrimaryActionButton(
                label: Strings.searchButton,
                onPressed: viewModel.displayState.isLoading() ? null : onRechercheButtonPressed,
              ),
              const SizedBox(height: Margins.spacing_m),
            ],
          ),
        );
      },
      distinct: true,
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
