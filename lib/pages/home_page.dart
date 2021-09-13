import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/pages/loader_page.dart';
import 'package:pass_emploi_app/pages/rendezvous_page.dart';
import 'package:pass_emploi_app/pages/user_action_page.dart';
import 'package:pass_emploi_app/presentation/home_item.dart';
import 'package:pass_emploi_app/presentation/home_page_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat_floating_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/user_action_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageViewModel>(
      converter: (store) => HomePageViewModel.create(store),
      builder: (context, viewModel) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _body(context, viewModel),
        );
      },
    );
  }

  _body(BuildContext context, HomePageViewModel viewModel) {
    if (viewModel.withLoading) return LoaderPage(screenHeight: MediaQuery.of(context).size.height);
    if (viewModel.withFailure) return _failure(viewModel);
    return _home(context, viewModel);
  }

  _failure(HomePageViewModel viewModel) {
    return Scaffold(
      appBar: _appBar(viewModel.title, viewModel.onRetry),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Erreur lors de la récupérations de ton tableau de bord."),
            TextButton(
              onPressed: () => viewModel.onRetry(),
              child: Text("Réessayer", style: TextStyles.textLgMedium),
            ),
            TextButton(
              onPressed: () => viewModel.onLogout(),
              child: Text("Me reconnecter", style: TextStyles.textLgMedium),
            ),
          ],
        ),
      ),
    );
  }

  _home(BuildContext context, HomePageViewModel viewModel) {
    return Scaffold(
      appBar: _appBar(viewModel.title, viewModel.onRetry),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.only(left: Margins.medium, right: Margins.medium),
          children: viewModel.items.map((item) => _listItem(context, item, viewModel)).toList(),
        ),
      ),
      floatingActionButton: ChatFloatingActionButton(),
    );
  }

  Widget _listItem(BuildContext context, HomeItem item, HomePageViewModel viewModel) {
    if (item is SectionItem) {
      return Padding(
        padding: const EdgeInsets.only(top: Margins.medium, bottom: Margins.medium),
        child: Text(item.title, style: TextStyles.textLgMedium),
      );
    } else if (item is MessageItem) {
      return Padding(
        padding: const EdgeInsets.only(top: Margins.medium, bottom: Margins.medium),
        child: Text(item.message, style: TextStyles.textSmRegular()),
      );
    } else if (item is ActionItem) {
      return Padding(
        padding: EdgeInsets.only(top: 6, bottom: 6),
        child: UserActionCard(action: item.action, onTap: () => _pushUserActionPage(context, viewModel)),
      );
    } else if (item is AllActionsButtonItem) {
      return Padding(
        padding: EdgeInsets.only(top: 6, bottom: 6),
        child: _allActionsButton(context, viewModel),
      );
    } else if (item is RendezvousItem) {
      return Padding(
        padding: EdgeInsets.only(top: 6, bottom: 6),
        child: RendezvousCard(
          rendezvous: item.rendezvous,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RendezvousPage(item.rendezvous)),
          ),
        ),
      );
    }
    return Container();
  }

  _appBar(String title, Function() onRetry) {
    return DefaultAppBar(
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.h3Semi),
          SizedBox(height: 4),
          Text('Bienvenue sur ton tableau de bord', style: TextStyles.textSmMedium()),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: onRetry,
            tooltip: "Rafraîchir",
            icon: SvgPicture.asset("assets/ic_refresh.svg"),
          ),
        ),
      ],
    );
  }

  _allActionsButton(BuildContext context, HomePageViewModel viewModel) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(color: AppColors.nightBlue, borderRadius: BorderRadius.all(Radius.circular(8))),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          onTap: () => _pushUserActionPage(context, viewModel),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(child: Text("Voir toutes les actions", style: TextStyles.textSmMedium(color: Colors.white))),
          ),
        ),
      ),
    );
  }

  _pushUserActionPage(BuildContext context, HomePageViewModel viewModel) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserActionPage(viewModel.userId)),
    ).then((value) {
      if (value == UserActionPageResult.UPDATED) viewModel.onRetry();
    });
  }
}
