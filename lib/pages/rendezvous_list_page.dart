import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/pages/rendezvous_page.dart';
import 'package:pass_emploi_app/presentation/rendezvous_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous_view_model.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/unavailable_content.dart';

class RendezvousListPage extends TraceableStatelessWidget {
  RendezvousListPage() : super(name: AnalyticsScreenNames.rendezvousList);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RendezvousListPageViewModel>(
      onInit: (store) => store.dispatch(RendezvousAction.request(Void)),
      converter: (store) => RendezvousListPageViewModel.create(store),
      builder: (context, viewModel) => _scaffold(_isPoleEmploiLogin(context)
          ? UnavailableContent(contentType: ContentType.RENDEZVOUS)
          : _body(context, viewModel)),
    );
  }

  Widget _body(BuildContext context, RendezvousListPageViewModel viewModel) {
    if (viewModel.withLoading) return _loader();
    if (viewModel.withFailure) return Retry(Strings.rendezVousError, () => viewModel.onRetry());
    if (viewModel.withEmptyMessage) return _empty();
    return _content(context, viewModel);
  }

  Widget _content(BuildContext context, RendezvousListPageViewModel viewModel) {
    return ListView(
      padding: const EdgeInsets.all(Margins.medium),
      children: viewModel.items.map((item) => _listItem(context, item)).toList(),
    );
  }

  Widget _listItem(BuildContext context, RendezvousViewModel viewModel) {
    return RendezvousCard(
      rendezvous: viewModel,
      onTap: () => Navigator.push(context, RendezvousPage.materialPageRoute(viewModel)),
    );
  }

  Widget _loader() => CircularProgressIndicator(color: AppColors.nightBlue);

  Widget _empty() {
    return Padding(
      padding: const EdgeInsets.all(Margins.medium),
      child: Text(Strings.noUpcomingRendezVous, style: TextStyles.textSmRegular()),
    );
  }

  Scaffold _scaffold(Widget body) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: Center(child: DefaultAnimatedSwitcher(child: body)),
    );
  }

  bool _isPoleEmploiLogin(BuildContext context) =>
      StoreProvider.of<AppState>(context).state.loginState.getResultOrThrow().loginMode == LoginMode.POLE_EMPLOI;
}
