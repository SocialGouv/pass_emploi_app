import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/pages/immersion_list_page.dart';
import 'package:pass_emploi_app/presentation/immersion_search_view_model.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/actions/actions.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/requests/Immersion_request.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/widgets/button.dart';
import 'package:pass_emploi_app/widgets/error_text.dart';
import 'package:pass_emploi_app/widgets/location_autocomplete.dart';
import 'package:pass_emploi_app/widgets/metier_autocomplete.dart';

class ImmersionSearchPage extends TraceableStatefulWidget {
  const ImmersionSearchPage() : super(name: AnalyticsScreenNames.immersionResearch);

  @override
  State<ImmersionSearchPage> createState() => _ImmersionSearchPageState();
}

class _ImmersionSearchPageState extends State<ImmersionSearchPage> {
  LocationViewModel? _selectedLocationViewModel;
  String? _selectedMetier;

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
          StoreProvider.of<AppState>(context).dispatch(ResetAction<ImmersionRequest, List<Immersion>>());
        }
      },
      onDispose: (store) {
        store.dispatch(ResetLocationAction());
        store.dispatch(ResetAction<ImmersionRequest, List<Immersion>>());
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
          Text(Strings.immersionLabel, style: TextStyles.textSmMedium()),
          SizedBox(height: 24),
          Text(Strings.metierCompulsoryLabel, style: TextStyles.textLgMedium),
          SizedBox(height: 24),
          MetierAutocomplete(onSelectMetier: (selectedMetierRome) => _selectedMetier = selectedMetierRome),
          SizedBox(height: 24),
          Text(Strings.villeCompulsoryLabel, style: TextStyles.textLgMedium),
          SizedBox(height: 24),
          LocationAutocomplete(
            onInputLocation: (newLocationQuery) => viewModel.onInputLocation(newLocationQuery),
            onSelectLocationViewModel: (locationViewModel) => _selectedLocationViewModel = locationViewModel,
            locationViewModels: viewModel.locations,
            hint: Strings.immersionFieldHint,
            getPreviouslySelectedTitle: () => _selectedLocationViewModel?.title,
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
                style: TextStyles.textMdMedium,
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

  List<Widget> _collapsableContent() {
    return [
      Text(Strings.immersionObjectifTitle, style: TextStyles.textSmMedium()),
      SizedBox(height: 16),
      Text(Strings.immersionObjectifContent, style: TextStyles.textSmRegular()),
      SizedBox(height: 24),
      Text(Strings.immersionDemarchesTitle, style: TextStyles.textSmMedium()),
      SizedBox(height: 16),
      Text(Strings.immersionDemarchesContent, style: TextStyles.textSmRegular()),
      SizedBox(height: 24),
      Text(Strings.immersionStatutTitle, style: TextStyles.textSmMedium()),
      SizedBox(height: 16),
      Text(Strings.immersionStatutContent, style: TextStyles.textSmRegular())
    ];
  }

  Column _stretchedButton(ImmersionSearchViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        primaryActionButton(
          onPressed: _isLoading(viewModel) ? null : () => _onSearchButtonPressed(viewModel),
          label: Strings.searchButton,
        ),
      ],
    );
  }

  bool _isLoading(ImmersionSearchViewModel viewModel) {
    return viewModel.displayState == ImmersionSearchDisplayState.SHOW_LOADER;
  }

  bool _isError(ImmersionSearchViewModel viewModel) {
    return viewModel.displayState == ImmersionSearchDisplayState.SHOW_ERROR ||
        viewModel.displayState == ImmersionSearchDisplayState.SHOW_EMPTY_ERROR;
  }

  void _onSearchButtonPressed(ImmersionSearchViewModel viewModel) {
    viewModel.onSearchingRequest(_selectedMetier, _selectedLocationViewModel?.location);
    Keyboard.dismiss(context);
  }
}
