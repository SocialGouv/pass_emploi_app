import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_list_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

import '../../presentation/location_view_model.dart';
import '../../presentation/service_civique_view_model.dart';
import '../../widgets/errors/error_text.dart';
import '../../widgets/location_autocomplete.dart';

class ServiceCiviqueSearchPage extends TraceableStatefulWidget {
  ServiceCiviqueSearchPage() : super(name: AnalyticsScreenNames.serviceCiviqueResearch);

  @override
  State<ServiceCiviqueSearchPage> createState() => _ServiceCiviqueSearchPageState();
}

class _ServiceCiviqueSearchPageState extends State<ServiceCiviqueSearchPage> {
  final _locationFormKey = GlobalKey<FormState>();
  var _shouldNavigate = true;
  LocationViewModel? _selectedLocationViewModel;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ServiceCiviqueViewModel>(
      converter: (store) => ServiceCiviqueViewModel.create(store),
      builder: _buildContent,
      onWillChange: (_, newViewModel) {
        if (newViewModel.displayState == DisplayState.CONTENT) {
          if (_shouldNavigate) {
            _shouldNavigate = false;
            widget.pushAndTrackBack(context, MaterialPageRoute(builder: (context) => ServiceCiviqueListPage()));
          }
        }
      },
      onDispose: (store) {
        store.dispatch(SearchLocationResetAction());
      },
      distinct: true,
    );
  }

  Padding _buildContent(BuildContext context, ServiceCiviqueViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Margins.spacing_s),
          Text(Strings.serviceCiviquePresentation, style: TextStyles.textBaseRegular),
          SizedBox(height: Margins.spacing_m),
          Text(Strings.villeNonCompulsoryLabel, style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_s),
          Text(Strings.selectACity, style: TextStyles.textSRegular()),
          SizedBox(height: Margins.spacing_s),
          LocationAutocomplete(
            onInputLocation: (newLocationQuery) => viewModel.onInputLocation(newLocationQuery),
            onSelectLocationViewModel: (locationViewModel) => _selectedLocationViewModel = locationViewModel,
            locationViewModels: viewModel.locations,
            hint: Strings.immersionFieldHint,
            getPreviouslySelectedTitle: () => null,
            formKey: _locationFormKey,
            validator: (value) {
              return null;
            },
          ),
          SizedBox(height: Margins.spacing_xl),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: PrimaryActionButton(
              onPressed: () {
                _shouldNavigate = true;
                viewModel.onSearchRequest(_selectedLocationViewModel?.location);
              },
              label: Strings.searchButton,
              iconSize: 18,
            ),
          ),
          if (viewModel.displayState == DisplayState.FAILURE) ErrorText(Strings.genericError),
          _buildCollapsableTile(context),
        ],
      ),
    );
  }

  Padding _buildCollapsableTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(
            Strings.knowMoreAboutServiceCivique,
            style: TextStyles.textBaseBold,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.topLeft,
          children: _collapsableContent(),
        ),
      ),
    );
  }

  List<Widget> _collapsableContent() {
    return [
      Text(Strings.knowMoreAboutServiceCiviqueFirstTitle, style: TextStyles.textSBold),
      SizedBox(height: Margins.spacing_base),
      Text(Strings.knowMoreAboutServiceCiviqueFirstText, style: TextStyles.textSRegular()),
      SizedBox(height: Margins.spacing_m),
      Text(Strings.knowMoreAboutServiceCiviqueSecondTitle, style: TextStyles.textSBold),
      SizedBox(height: Margins.spacing_base),
      Text(Strings.knowMoreAboutServiceCiviqueSecondText, style: TextStyles.textSRegular()),
      SizedBox(height: Margins.spacing_m),
      Text(Strings.knowMoreAboutServiceCiviqueThirdTitle, style: TextStyles.textSBold),
      SizedBox(height: Margins.spacing_base),
      Text(Strings.knowMoreAboutServiceCiviqueThirdText, style: TextStyles.textSRegular()),
      SizedBox(height: Margins.spacing_m),
      Text(Strings.knowMoreAboutServiceCiviqueFourthTitle, style: TextStyles.textSBold),
      SizedBox(height: Margins.spacing_base),
      Text(Strings.knowMoreAboutServiceCiviqueFourthText, style: TextStyles.textSRegular()),
      SizedBox(height: Margins.spacing_m),
      Text(Strings.knowMoreAboutServiceCiviqueLastTitle, style: TextStyles.textSBold),
      SizedBox(height: Margins.spacing_base),
    ];
  }
}
