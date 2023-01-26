import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_actions.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/pages/offre_emploi_filtres_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_results_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/utils/log.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/offre_emploi_saved_search_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/filtre_button.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:pass_emploi_app/widgets/location_autocomplete.dart';

class RechercheOffreEmploiPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheOffreEmploiPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: passEmploiAppBar(label: 'Offres Emploi', context: context, withBackButton: true),
      body: StoreConnector<AppState, OffreEmploiSearchViewModel>(
        converter: (store) => OffreEmploiSearchViewModel.create(store),
        builder: (context, vm) => _Body(vm),
        onDispose: (store) {
          store.dispatch(OffreEmploiSearchResetAction());
          //TODO: probablement reset aussi les Params, ou ailleurs ?
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final OffreEmploiSearchViewModel viewModel;

  _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    final rechercheInitiale =
        viewModel.searchDisplayState != DisplayState.CONTENT && viewModel.resultDisplayState != DisplayState.CONTENT;
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (rechercheInitiale) ...[
            _ParametresRechercheOuvert(viewModel),
            if (viewModel.searchDisplayState == DisplayState.FAILURE) Text("FAILURE"),
            if (viewModel.searchDisplayState == DisplayState.LOADING) Text("LOADER"),
            Text("TODO Design pour lancer la recherche + illus"),
          ] else ...[
            _ParametresRechercheSwitcher(
              viewModel: viewModel,
              nombreDeCriteres: viewModel.nombreDeCriteres,
            ),
            Expanded(child: _ResultatRecherche()),
          ],
        ],
      ),
    );
  }
}

class _ParametresRechercheSwitcher extends StatefulWidget {
  final OffreEmploiSearchViewModel viewModel;
  final int nombreDeCriteres;

  const _ParametresRechercheSwitcher({required this.viewModel, required this.nombreDeCriteres});

  @override
  State<_ParametresRechercheSwitcher> createState() => _ParametresRechercheSwitcherState();
}

class _ParametresRechercheSwitcherState extends State<_ParametresRechercheSwitcher> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.bounceIn,
      child: _expanded
          ? _ParametresRechercheOuvert(widget.viewModel)
          : InkWell(
              child: _ParametresRechercheFerme(nombreDeCriteres: widget.nombreDeCriteres),
              onTap: () => setState(() {
                widget.viewModel.onClearSearch();
                _expanded = !_expanded;
              }),
            ),
    );
  }
}

class _ParametresRechercheFerme extends StatelessWidget {
  final int nombreDeCriteres;

  const _ParametresRechercheFerme({required this.nombreDeCriteres});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radius_s),
        color: AppColors.primary,
      ),
      padding: EdgeInsets.all(Margins.spacing_base),
      child: Row(
        children: [
          SvgPicture.asset(Drawables.icSearch, color: Colors.white),
          SizedBox(width: Margins.spacing_base),
          Text(
            "($nombreDeCriteres) critères actifs", //TODO extract string:
            style: TextStyles.textBaseBoldWithColor(Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ParametresRechercheOuvert extends StatefulWidget {
  final OffreEmploiSearchViewModel viewModel;

  _ParametresRechercheOuvert(this.viewModel);

  @override
  State<_ParametresRechercheOuvert> createState() => _ParametresRechercheOuvertState();
}

class _ParametresRechercheOuvertState extends State<_ParametresRechercheOuvert> {
  int? criteresActifsCount;
  var _keyWord = "";
  LocationViewModel? _selectedLocationViewModel;

  @override
  void initState() {
    _keyWord = widget.viewModel.selectedKeyWord;
    if (widget.viewModel.selectedLocation != null) {
      _selectedLocationViewModel = LocationViewModel.fromLocation(widget.viewModel.selectedLocation!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        children: [
          Text("(${criteresActifsCount ?? widget.viewModel.nombreDeCriteres}) critères actifs"),
          Text("mots:"),
          TextFormField(
            style: TextStyles.textBaseBold,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            decoration: _inputDecoration(),
            onChanged: (keyword) {
              _keyWord = keyword;
              setState(() => _updateCriteresActifsCount());
            },
            initialValue: _keyWord,
          ),
          Text("localisation:"),
          LocationAutocomplete(
            onInputLocation: (newLocationQuery) => widget.viewModel.onInputLocation(newLocationQuery),
            onSelectLocationViewModel: (locationViewModel) {
              _selectedLocationViewModel = locationViewModel;
              setState(() => _updateCriteresActifsCount());
            },
            locationViewModels: widget.viewModel.locations,
            hint: Strings.jobLocationHint,
            getPreviouslySelectedTitle: () => _selectedLocationViewModel?.title,
            formKey: null,
            validator: (value) => null,
            initialValue: _selectedLocationViewModel?.title,
          ),
          PrimaryActionButton(
            onPressed: widget.viewModel.searchDisplayState.isLoading()
                ? null
                : () => _onSearchButtonPressed(context, widget.viewModel),
            label: Strings.searchButton,
          ),
        ],
      ),
    );
  }

  void _updateCriteresActifsCount() {
    var criteresActifsCount = 0;
    criteresActifsCount += _keyWord.isNotEmpty ? 1 : 0;
    criteresActifsCount += _selectedLocationViewModel != null ? 1 : 0;
    this.criteresActifsCount = criteresActifsCount;
  }

  void _onSearchButtonPressed(BuildContext context, OffreEmploiSearchViewModel viewModel) {
    viewModel.onSearchingRequest(_keyWord, _selectedLocationViewModel?.location, false); //TODO: alternance/emploi
    Keyboard.dismiss(context);
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

class _ResultatRecherche extends StatefulWidget {
  @override
  State<_ResultatRecherche> createState() => _ResultatRechercheState();
}

class _ResultatRechercheState extends State<_ResultatRecherche> {
  late ScrollController _scrollController;
  OffreEmploiSearchResultsViewModel? _currentViewModel;
  double _offsetBeforeLoading = 0;
  bool _shouldLoadAtBottom = true;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_shouldLoadAtBottom && _scrollController.offset >= _scrollController.position.maxScrollExtent) {
        Log.i("######### SHOULD LOAD MORE, _currentViewModel = $_currentViewModel");
        _offsetBeforeLoading = _scrollController.offset;
        _currentViewModel?.onLoadMore();
      } else {
        Log.i("#### SHOULD NOT LOAD MORE, _currentViewModel = $_currentViewModel");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiSearchResultsViewModel>(
      converter: (store) => OffreEmploiSearchResultsViewModel.create(store),
      onInitialBuild: (viewModel) => _currentViewModel = viewModel,
      builder: (context, viewModel) => FavorisStateContext<OffreEmploi>(
        selectState: (store) => store.state.offreEmploiFavorisState,
        child: Stack(
          children: [
            // TODO gérer empty si rien trouvé
            ListView.separated(
              padding: EdgeInsets.only(top: Margins.spacing_base, bottom: 160),
              controller: _scrollController,
              itemBuilder: (context, index) => _buildOffreItem(context, index, viewModel),
              separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
              itemCount: viewModel.items.length,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    if (viewModel.withAlertButton) _alertPrimaryButton(context, viewModel),
                    if (viewModel.withFiltreButton) _filtrePrimaryButton(context, viewModel),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      onDidChange: _onDidChange,
      distinct: true,
    );
  }

  void _onDidChange(OffreEmploiSearchResultsViewModel? previousViewModel, OffreEmploiSearchResultsViewModel viewModel) {
    _currentViewModel = viewModel;
    if (_scrollController.hasClients) _scrollController.jumpTo(_offsetBeforeLoading);
    _shouldLoadAtBottom = viewModel.displayLoaderAtBottomOfList && viewModel.displayState != DisplayState.FAILURE;
  }

  Widget _buildOffreItem(
    BuildContext context,
    int index,
    OffreEmploiSearchResultsViewModel resultsViewModel,
  ) {
    final OffreEmploiItemViewModel item = resultsViewModel.items[index];
    return DataCard<OffreEmploi>(
      titre: item.title,
      sousTitre: item.companyName,
      lieu: item.location,
      id: item.id,
      dataTag: [item.contractType, item.duration ?? ''],
      onTap: () => {},
      //TODO: tap
      from: OffrePage.emploiResults, //TODO: alternance ou emploi
    );
  }

  Widget _filtrePrimaryButton(BuildContext context, OffreEmploiSearchResultsViewModel viewModel) {
    return FiltreButton.primary(
      filtresCount: viewModel.filtresCount,
      onPressed: () => _onFiltreButtonPressed(context),
    );
  }

  Future<void> _onFiltreButtonPressed(BuildContext context) {
    return Navigator.push(
      context,
      OffreEmploiFiltresPage.materialPageRoute(true), // TODO alternance ou emploi
    ).then((value) {
      if (value == true) {
        // TODO or not TODO ?
        //_offsetBeforeLoading = 0;
        //if (_scrollController.hasClients) _scrollController.jumpTo(_offsetBeforeLoading);
      }
    });
  }

  Widget _alertPrimaryButton(BuildContext context, OffreEmploiSearchResultsViewModel viewModel) {
    return PrimaryActionButton(
      label: Strings.createAlert,
      drawableRes: Drawables.icAlert,
      rippleColor: AppColors.primaryDarken,
      heightPadding: 6,
      widthPadding: 6,
      iconSize: 16,
      onPressed: () => _onAlertButtonPressed(context),
    );
  }

  void _onAlertButtonPressed(BuildContext context) {
    showPassEmploiBottomSheet(
      context: context,
      builder: (context) => OffreEmploiSavedSearchBottomSheet(onlyAlternance: true), // TODO alternance ou emploi
    );
  }
}
