import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_critereres_cherche_contenu_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_critereres_cherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/location_autocomplete.dart';

class CriteresRecherche extends StatefulWidget {
  @override
  State<CriteresRecherche> createState() => _CriteresRechercheState();
}

class _CriteresRechercheState extends State<CriteresRecherche> {
  bool isOpen = true;
  int? _criteresActifsCount;
  LocationViewModel? _selectedLocationViewModel;
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCriteresRechercheViewModel>(
      converter: (store) => BlocCriteresRechercheViewModel.create(store),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, BlocCriteresRechercheViewModel viewModel) {
    final mainAnimationDuration = Duration(milliseconds: 300);
    const mainAnimationCurve = Curves.ease;
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: isOpen ? Colors.white : AppColors.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [Shadows.boxShadow],
      ),
      duration: mainAnimationDuration,
      curve: mainAnimationCurve,
      child: Column(
        children: [
          RechercheBandeau(
            isOpen: isOpen,
            criteresActifsCount: _criteresActifsCount ?? 0,
            onPressed: () {
              _onExpensionChanged();
              viewModel.onExpansionChanged(isOpen);
            },
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: _CriteresRechercheContenu(
              onKeywordChanged: (keyword) {
                _keyword = keyword;
                setState(() => _updateCriteresActifsCount());
              },
              onSelectLocationViewModel: (locationVM) {
                _selectedLocationViewModel = locationVM;
                setState(() => _updateCriteresActifsCount());
              },
              getPreviouslySelectedTitle: () => _selectedLocationViewModel?.title,
              onRechercheButtonPressed: () {
                _onExpensionChanged();
                // TODO: 1353 - only alternance
                viewModel.onSearchingRequest(_keyword, _selectedLocationViewModel?.location, false);
                Keyboard.dismiss(context);
              },
            ),
            crossFadeState: isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: mainAnimationDuration,
            sizeCurve: mainAnimationCurve,
          ),
        ],
      ),
    );
    // return Column(
    //   children: [
    //     CejExpansionTile(
    //       key: _expansionTileKey,
    //       onExpansionChanged: viewModel.onExpansionChanged,
    //       maintainState: true,
    //       backgroundColor: Colors.white,
    //       textColor: AppColors.primary,
    //       iconColor: AppColors.primary,
    //       collapsedBackgroundColor: AppColors.primary,
    //       collapsedTextColor: Colors.white,
    //       collapsedIconColor: Colors.white,
    //       leading: Icon(Icons.search),
    //       title: _CriteresRechercheBandeau(criteresActifsCount: _criteresActifsCount ?? 0),
    //       initiallyExpanded: viewModel.isOpen,
    //       children: [
    //         _CriteresRechercheContenu(
    //           onKeywordChanged: (keyword) {
    //             _keyword = keyword;
    //             setState(() => _updateCriteresActifsCount());
    //           },
    //           onSelectLocationViewModel: (locationVM) {
    //             _selectedLocationViewModel = locationVM;
    //             setState(() => _updateCriteresActifsCount());
    //           },
    //           getPreviouslySelectedTitle: () => _selectedLocationViewModel?.title,
    //           onRechercheButtonPressed: () {
    //             // TODO: 1353 - only alternance
    //             viewModel.onSearchingRequest(_keyword, _selectedLocationViewModel?.location, false);
    //             Keyboard.dismiss(context);
    //           },
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }

  void _onExpensionChanged() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  void _updateCriteresActifsCount() {
    int criteresActifsCount = 0;
    criteresActifsCount += _keyword.isNotEmpty ? 1 : 0;
    criteresActifsCount += _selectedLocationViewModel != null ? 1 : 0;
    _criteresActifsCount = criteresActifsCount;
  }
}

class RechercheBandeau extends StatelessWidget {
  final int criteresActifsCount;
  final void Function() onPressed;
  final bool isOpen;
  const RechercheBandeau({
    super.key,
    required this.criteresActifsCount,
    required this.onPressed,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final color = isOpen ? Colors.black : Colors.white;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.all(Margins.spacing_base),
            child: Row(
              children: [
                Icon(Icons.search, color: !isOpen ? Colors.white : AppColors.primary),
                SizedBox(width: Margins.spacing_base),
                Expanded(
                    child: _CriteresRechercheBandeau(
                  criteresActifsCount: criteresActifsCount,
                  color: color,
                )),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                  child: Icon(Icons.expand_less_rounded, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CriteresRechercheBandeau extends StatelessWidget {
  final int criteresActifsCount;
  final Color color;

  const _CriteresRechercheBandeau({required this.criteresActifsCount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      Intl.plural(
        criteresActifsCount,
        zero: Strings.rechercheCriteresActifsSingular(criteresActifsCount),
        one: Strings.rechercheCriteresActifsSingular(criteresActifsCount),
        other: Strings.rechercheCriteresActifsPlural(criteresActifsCount),
      ),
      style: TextStyles.textBaseMediumBold(color: color),
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
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, BlocCriteresRechercheContenuViewModel viewModel) {
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
