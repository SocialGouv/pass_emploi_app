import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_details_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/calendar_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class RendezvousListPage extends TraceableStatelessWidget {
  RendezvousListPage() : super(name: AnalyticsScreenNames.rendezvousList);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RendezvousListViewModel>(
      onInit: (store) => store.dispatch(RendezvousRequestAction()),
      converter: (store) => RendezvousListViewModel.create(store),
      builder: (context, viewModel) {
        return _Scaffold(
          body: _Body(
            viewModel: viewModel,
            onTap: (viewModel) =>
                pushAndTrackBack(context, RendezvousDetailsPage.materialPageRoute(viewModel.id, viewModel)),
          ),
        );
      },
      onDidChange: (_, viewModel) => _openDeeplinkIfNeeded(viewModel, context),
      distinct: true,
    );
  }

  void _openDeeplinkIfNeeded(RendezvousListViewModel viewModel, BuildContext context) {
    if (viewModel.deeplinkRendezvous != null) {
      pushAndTrackBack(context,
          RendezvousDetailsPage.materialPageRoute(viewModel.deeplinkRendezvous!.id, viewModel.deeplinkRendezvous!));
      viewModel.onDeeplinkUsed();
    }
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold({Key? key, required this.body}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Center(child: DefaultAnimatedSwitcher(child: body)),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key, required this.viewModel, required this.onTap}) : super(key: key);

  final RendezvousListViewModel viewModel;
  final Function(RendezvousCardViewModel) onTap;

  @override
  Widget build(BuildContext context) {
    switch (viewModel.displayState) {
      case DisplayState.LOADING:
        return CircularProgressIndicator();
      case DisplayState.FAILURE:
        return Retry(Strings.rendezVousError, () => viewModel.onRetry());
      case DisplayState.EMPTY:
        return _Empty();
      case DisplayState.CONTENT:
        return _Content(
          viewModel: viewModel,
          onTap: (viewModel) => onTap(viewModel),
        );
    }
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key, required this.viewModel, required this.onTap}) : super(key: key);

  final RendezvousListViewModel viewModel;
  final Function(RendezvousCardViewModel) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: viewModel.items.length,
      padding: const EdgeInsets.all(Margins.spacing_s),
      separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
      itemBuilder: (context, index) {
        final vm = viewModel.items[index];
        return CalendarCard(
          tag: vm.tag,
          date: vm.date,
          titre: vm.title,
          sousTitre: vm.subtitle,
          texteLien: Strings.linkDetailsRendezVous,
          onTap: () => onTap(vm),
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Text(Strings.noUpcomingRendezVous, style: TextStyles.textSRegular()),
    );
  }
}
