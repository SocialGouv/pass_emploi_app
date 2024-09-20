import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/event_list_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_evenement_emploi_page.dart';
import 'package:pass_emploi_app/presentation/events/event_tab_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/onboarding/onboarding_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_tab_bar.dart';

class EventsTabPage extends StatefulWidget {
  final EventTab? initialTab;

  EventsTabPage({this.initialTab});

  @override
  State<EventsTabPage> createState() => _EventsTabPageState();
}

class _EventsTabPageState extends State<EventsTabPage> {
  bool _onboardingShown = false;

  @override
  Widget build(BuildContext context) {
    return AutoFocusA11y(
      child: StoreConnector<AppState, EventsTabPageViewModel>(
        builder: (context, viewModel) => _Body(viewModel, widget.initialTab),
        converter: (store) => EventsTabPageViewModel.create(store, releaseMode: kReleaseMode),
        onDidChange: (_, newVm) => _handleOnboarding(newVm),
      ),
    );
  }

  void _handleOnboarding(EventsTabPageViewModel viewModel) {
    if (viewModel.shouldShowOnboarding && !_onboardingShown) {
      _onboardingShown = true;
      OnboardingBottomSheet.show(context, source: OnboardingSource.evenements);
    }
  }
}

class _Body extends StatelessWidget {
  final EventsTabPageViewModel viewModel;
  final EventTab? initialTab;

  _Body(this.viewModel, this.initialTab);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: PrimaryAppBar(title: Strings.eventAppBarTitle),
      body: ConnectivityContainer(
        child: DefaultTabController(
          initialIndex: viewModel.tabs._index(initialTab),
          length: viewModel.tabs.length,
          child: Builder(builder: (context) {
            if (viewModel.tabs.length == 1) return viewModel.tabs._pages()[0];
            return Column(
              children: [
                PassEmploiTabBar(tabLabels: viewModel.tabs._titles()),
                Expanded(
                  child: TabBarView(
                    children: viewModel.tabs._pages(),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

extension _Tabs on List<EventTab> {
  int _index(EventTab? tab) {
    if (tab == null) return 0;
    final index = indexOf(tab);
    return index == -1 ? 0 : index;
  }

  List<Widget> _pages() {
    return map((tab) {
      return switch (tab) {
        EventTab.maMissionLocale => EventListPage(),
        EventTab.rechercheExternes => RechercheEvenementEmploiPage()
      };
    }).toList();
  }

  List<String> _titles() {
    return map((tab) {
      return switch (tab) {
        EventTab.maMissionLocale => Strings.eventTabMaMissionLocale,
        EventTab.rechercheExternes => Strings.eventTabExternes
      };
    }).toList();
  }
}
