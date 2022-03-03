import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/pages/rendezvous_page.dart';
import 'package:pass_emploi_app/presentation/rendezvous_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous_view_model.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
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
    return StoreConnector<AppState, RendezvousListPageViewModel>(
      onInit: (store) => store.dispatch(RendezvousAction.request(Void)),
      converter: (store) => RendezvousListPageViewModel.create(store),
      builder: (context, viewModel) => _scaffold(_body(context, viewModel)),
      onDidChange: (_, viewModel) => _openDeeplinkIfNeeded(viewModel, context),
      distinct: true,
    );
  }

  void _openDeeplinkIfNeeded(RendezvousListPageViewModel viewModel, BuildContext context) {
    if (viewModel.deeplinkRendezvous != null) {
      pushAndTrackBack(context, RendezvousPage.materialPageRoute(viewModel.deeplinkRendezvous!));
      viewModel.onDeeplinkUsed();
    }
  }

  Widget _body(BuildContext context, RendezvousListPageViewModel viewModel) {
    if (viewModel.withLoading) return _loader();
    if (viewModel.withFailure) return Retry(Strings.rendezVousError, () => viewModel.onRetry());
    if (viewModel.withEmptyMessage) return _empty();
    return _content(context, viewModel);
  }

  Widget _content(BuildContext context, RendezvousListPageViewModel viewModel) {
    return ListView.separated(
      itemCount: viewModel.items.length,
      padding: const EdgeInsets.all(Margins.spacing_s),
      separatorBuilder: (context, index) => Container(
        height: Margins.spacing_base,
      ),
      itemBuilder: (context, index) => _listItem(context, viewModel.items[index]),
    );
  }

  Widget _listItem(BuildContext context, RendezvousViewModel viewModel) {
    return CalendarCard(
      date: viewModel.dateAndHour,
      titre: viewModel.title,
      sousTitre: viewModel.subtitle,
      texteLien: Strings.linkDetailsRendezVous,
      onTap: () => pushAndTrackBack(context, RendezvousPage.materialPageRoute(viewModel)),
    );
  }

  Widget _loader() => CircularProgressIndicator(color: AppColors.primary);

  Widget _empty() {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Text(Strings.noUpcomingRendezVous, style: TextStyles.textSRegular()),
    );
  }

  Scaffold _scaffold(Widget body) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Center(child: DefaultAnimatedSwitcher(child: body)),
    );
  }
}
