import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_details_page.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
import 'package:pass_emploi_app/presentation/agenda/agenda_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/user_action_create_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/cards/user_action_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';

// todo Cacher onglet "Cette semaine" quand on est PE ?

class AgendaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: "todo", // todo tracking
      child: StoreConnector<AppState, AgendaPageViewModel>(
        onInit: (store) => store.dispatch(AgendaRequestAction(DateTime.now())),
        builder: (context, viewModel) => _Scaffold(body: _Body(viewModel: viewModel)),
        converter: (store) => AgendaPageViewModel.create(store),
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold({Key? key, required this.body}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Stack(children: [
        DefaultAnimatedSwitcher(child: body),
        _CreateActionButton(),
      ]),
    );
  }
}

class _CreateActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: PrimaryActionButton(
          label: Strings.addAnAction,
          drawableRes: Drawables.icAdd,
          rippleColor: AppColors.primaryDarken,
          onPressed: () => showPassEmploiBottomSheet(
            context: context,
            builder: (context) => CreateUserActionBottomSheet(),
          ).then((value) => {}), // todo reset comme sur user_action_list_page ?? à creuser, pour voir s'il faut ou non faire store.dispatch(UserActionCreateResetAction()) dans notre VM
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final AgendaPageViewModel viewModel;

  const _Body({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (viewModel.displayState) {
      case DisplayState.LOADING:
        return CircularProgressIndicator();
      case DisplayState.CONTENT:
        return _Content(viewModel: viewModel);
      default:
        return Text("Sorry :)");
    }
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final AgendaPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: ListView.builder(
        itemCount: viewModel.events.length,
        itemBuilder: (context, index) => _DaySection(viewModel.events[index]),
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  final DaySectionAgenda section;

  _DaySection(this.section);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _DaySectionTitle(section.title),
      ...section.events.widgets(context),
    ]);
  }
}

class _DaySectionTitle extends StatelessWidget {
  final String title;

  _DaySectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_base, bottom: Margins.spacing_s),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: TextStyles.textBaseMedium),
      ),
    );
  }
}

extension _EventWidgets on List<EventAgenda> {
  List<Widget> widgets(BuildContext context) {
    return map((event) {
      if (event is UserActionEventAgenda) {
        return _ActionCard(id: event.id);
      } else if (event is RendezvousEventAgenda) {
        return event.rendezvousCard(context);
      } else {
        return SizedBox(height: 0);
      }
    }).toList();
  }
}

extension _EventWidget on RendezvousEventAgenda {
  Widget rendezvousCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      child: RendezvousCard(
        converter: (store) => RendezvousCardViewModel.createFromAgendaState(store, id),
        onTap: () {
          context.trackEvent(EventType.RDV_DETAIL);
          Navigator.push(
            context,
            RendezvousDetailsPage.materialPageRoute(id),
          );
        },
      ),
    );
  }
}

// todo mutualiser, onTap en param

class _ActionCard extends StatelessWidget {
  final String id;

  _ActionCard({required this.id});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionViewModel>(
      builder: (context, viewModel) => _card(context, viewModel),
      converter: (store) => UserActionViewModel.createFromAgendaState(store, id),
      distinct: true,
    );
  }

  Widget _card(BuildContext context, UserActionViewModel viewModel) {
    return UserActionCard(
      onTap: () {
        context.trackEvent(EventType.ACTION_DETAIL);
        Navigator.push(
          context,
          UserActionDetailPage.materialPageRoute(viewModel),
        );
      },
      viewModel: viewModel,
    );
  }
}
