import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/pages/immersion_list_page.dart';
import 'package:pass_emploi_app/presentation/immersion_search_view_model.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/actions/search_metier_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/location_autocomplete.dart';
import 'package:pass_emploi_app/widgets/metier_autocomplete.dart';

class ImmersionSearchPage extends TraceableStatefulWidget {
  const ImmersionSearchPage() : super(name: AnalyticsScreenNames.immersionResearch);

  @override
  State<ImmersionSearchPage> createState() => _ImmersionSearchPageState();
}

class _ImmersionSearchPageState extends State<ImmersionSearchPage> {
  LocationViewModel? _selectedLocationViewModel;
  String? _selectedMetierCodeRome;
  String? _selectedMetierTitle;
  final _metierFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ImmersionSearchViewModel>(
      converter: (store) => ImmersionSearchViewModel.create(store),
      builder: (context, vm) => _content(context, vm),
      distinct: true,
      onWillChange: (_, viewModel) {
        if (viewModel.displayState == ImmersionSearchDisplayState.SHOW_RESULTS) {
          widget
              .pushAndTrackBack(
                  context, MaterialPageRoute(builder: (context) => ImmersionListPage(viewModel.immersions)))
              .then((_) {
            // Reset state to avoid unexpected SHOW_RESULTS while coming back from ImmersionListPage
            StoreProvider.of<AppState>(context).dispatch(ImmersionListResetAction());
          });
        }
      },
      onDispose: (store) {
        store.dispatch(ResetLocationAction());
        store.dispatch(ResetMetierAction());
        store.dispatch(ImmersionListResetAction());
      },
    );
  }

  Padding _content(BuildContext context, ImmersionSearchViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Margins.spacing_m),
          Text(Strings.immersionLabel, style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_m),
          Text(Strings.metierCompulsoryLabel, style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_base),
          MetierAutocomplete(
            onInputMetier: (newMetierQuery) => viewModel.onInputMetier(newMetierQuery),
            metiers: viewModel.metiers,
            onSelectMetier: (selectedMetier) {
              setState(() {
                _setSelectedMetier(selectedMetier);
              });
            },
            formKey: _metierFormKey,
            getPreviouslySelectedTitle: () => _selectedMetierTitle,
            validator: (value) {
              if (value == null || value.isEmpty || _selectedMetierCodeRome == null) {
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
            onSelectLocationViewModel: (locationViewModel) => _selectedLocationViewModel = locationViewModel,
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
          SizedBox(height: Margins.spacing_m),
          _stretchedButton(viewModel),
          if (_isError(viewModel)) ErrorText(viewModel.errorMessage),
          SizedBox(height: Margins.spacing_m),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                Strings.immersionExpansionTileTitle,
                style: TextStyles.textBaseBold,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              expandedAlignment: Alignment.topLeft,
              children: _collapsableContent(),
            ),
          ),
        ],
      ),
    );
  }

  _setSelectedMetier(Metier? selectedMetier) {
    if (selectedMetier != null) {
      _selectedMetierCodeRome = selectedMetier.codeRome;
      _selectedMetierTitle = selectedMetier.libelle;
    } else {
      _selectedMetierCodeRome = null;
      _selectedMetierTitle = null;
    }
  }

  List<Widget> _collapsableContent() {
    return [
      Text(Strings.immersionObjectifTitle, style: TextStyles.textSBold),
      SizedBox(height: Margins.spacing_base),
      Text(Strings.immersionObjectifContent, style: TextStyles.textSRegular()),
      SizedBox(height: Margins.spacing_m),
      Text(Strings.immersionDemarchesTitle, style: TextStyles.textSBold),
      SizedBox(height: Margins.spacing_base),
      Text(Strings.immersionDemarchesContent, style: TextStyles.textSRegular()),
      SizedBox(height: Margins.spacing_m),
      Text(Strings.immersionStatutTitle, style: TextStyles.textSBold),
      SizedBox(height: Margins.spacing_base),
      Text(Strings.immersionStatutContent, style: TextStyles.textSRegular())
    ];
  }

  Column _stretchedButton(ImmersionSearchViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryActionButton(
          label: Strings.searchButton,
          onPressed: !_isLoading(viewModel) && _isFormValid() ? () => _onSearchButtonPressed(viewModel) : null,
        ),
      ],
    );
  }

  bool _isFormValid() => _isMetierFormValid() && _locationFormKey.currentState?.validate() == true;

  bool _isMetierFormValid() => _selectedMetierCodeRome != null && _metierFormKey.currentState?.validate() == true;

  bool _isLoading(ImmersionSearchViewModel vm) => vm.displayState == ImmersionSearchDisplayState.SHOW_LOADER;

  bool _isError(ImmersionSearchViewModel vm) => vm.displayState == ImmersionSearchDisplayState.SHOW_ERROR;

  void _onSearchButtonPressed(ImmersionSearchViewModel viewModel) {
    viewModel.onSearchingRequest(_selectedMetierCodeRome, _selectedLocationViewModel?.location);
    Keyboard.dismiss(context);
  }
}
