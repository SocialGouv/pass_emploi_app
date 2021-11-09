import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/rendezvous_page.dart';
import 'package:pass_emploi_app/presentation/rendezvous_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/rendezvous_card.dart';

class RendezvousListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RendezvousListPageViewModel>(
      onInit: (store) => store.dispatch(RequestRendezvousAction()),
      builder: (context, viewModel) => _body(context, viewModel),
      converter: (store) => RendezvousListPageViewModel.create(store),
    );
  }

  Widget _body(BuildContext context, RendezvousListPageViewModel viewModel) {
    if (viewModel.withLoading) return _loader();
    if (viewModel.withFailure) return _failure(viewModel);
    if (viewModel.withEmptyMessage) return _empty();
    return _content(context, viewModel);
  }

  Widget _content(BuildContext context, RendezvousListPageViewModel viewModel) {
    return _scaffold(ListView(
      padding: const EdgeInsets.all(Margins.medium),
      children: viewModel.items.map((item) => _listItem(context, item)).toList(),
    ));
  }

  Widget _listItem(BuildContext context, RendezvousViewModel viewModel) {
    return RendezvousCard(
      rendezvous: viewModel,
      onTap: () => Navigator.push(context, RendezvousPage.materialPageRoute(viewModel)),
    );
  }

  Widget _loader() => _scaffold(Center(child: CircularProgressIndicator(color: AppColors.nightBlue)));

  Widget _empty() {
    return _scaffold(Center(
      child: Padding(
        padding: const EdgeInsets.all(Margins.medium),
        child: Text(
          Strings.noUpcomingRendezVous,
          style: TextStyles.textSmRegular(),
        ),
      ),
    ));
  }

  Widget _failure(RendezvousListPageViewModel viewModel) {
    return _scaffold(Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Strings.actionsError),
          TextButton(onPressed: () => viewModel.onRetry(), child: Text(Strings.retry, style: TextStyles.textLgMedium)),
        ],
      ),
    ));
  }

  Widget _scaffold(Widget body) => Scaffold(backgroundColor: AppColors.lightBlue, appBar: _appBar(), body: body);

  AppBar _appBar() => FlatDefaultAppBar(title: Text(Strings.rendezvousListPageTitle, style: TextStyles.h3Semi));
}
