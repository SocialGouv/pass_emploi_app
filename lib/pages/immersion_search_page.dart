import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/pages/immersion_list_page.dart';
import 'package:pass_emploi_app/presentation/immersion_search_view_model.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/widgets/error_text.dart';
import 'package:pass_emploi_app/widgets/location_autocomplete.dart';
import 'package:pass_emploi_app/widgets/metier_autocomplete.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';

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
          Navigator.push(context, MaterialPageRoute(builder: (context) => ImmersionListPage(viewModel.immersions)));
          // Reset state to avoid unexpected SHOW_RESULTS while coming back from ImmersionListPage
          StoreProvider.of<AppState>(context).dispatch(ImmersionAction.reset());
        }
      },
      onDispose: (store) {
        store.dispatch(ResetLocationAction());
        store.dispatch(ImmersionAction.reset());
      },
    );
  }

  Padding _content(BuildContext context, ImmersionSearchViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Text(Strings.immersionLabel, style: TextStyles.textBaseBold),
          SizedBox(height: 24),
          Text(Strings.metierCompulsoryLabel, style: TextStyles.textLgMedium),
          SizedBox(height: 24),
          MetierAutocomplete(
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
          SizedBox(height: 24),
          Text(Strings.villeCompulsoryLabel, style: TextStyles.textLgMedium),
          SizedBox(height: 24),
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
          SizedBox(height: 24),
          _stretchedButton(viewModel),
          if (_isError(viewModel)) ErrorText(viewModel.errorMessage),
          SizedBox(height: 24),
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
      SizedBox(height: 16),
      Text(Strings.immersionObjectifContent, style: TextStyles.textSRegular()),
      SizedBox(height: 24),
      Text(Strings.immersionDemarchesTitle, style: TextStyles.textSBold),
      SizedBox(height: 16),
      Text(Strings.immersionDemarchesContent, style: TextStyles.textSRegular()),
      SizedBox(height: 24),
      Text(Strings.immersionStatutTitle, style: TextStyles.textSBold),
      SizedBox(height: 16),
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

  bool _isLoading(ImmersionSearchViewModel viewModel) {
    return viewModel.displayState == ImmersionSearchDisplayState.SHOW_LOADER;
  }

  bool _isError(ImmersionSearchViewModel viewModel) {
    if (viewModel.displayState == ImmersionSearchDisplayState.SHOW_EMPTY_ERROR)
      MatomoTracker.trackScreenWithName(
          AnalyticsScreenNames.immersionNoResults, AnalyticsScreenNames.immersionResearch);

    return viewModel.displayState == ImmersionSearchDisplayState.SHOW_ERROR ||
        viewModel.displayState == ImmersionSearchDisplayState.SHOW_EMPTY_ERROR;
  }

  void _onSearchButtonPressed(ImmersionSearchViewModel viewModel) {
    viewModel.onSearchingRequest(_selectedMetierCodeRome, _selectedLocationViewModel?.location);
    Keyboard.dismiss(context);
  }
}
