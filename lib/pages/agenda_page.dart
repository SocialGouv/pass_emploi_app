import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_details_page.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
import 'package:pass_emploi_app/presentation/agenda/agenda_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_details_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/big_title_separator.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/user_action_create_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/cards/user_action_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class AgendaPage extends StatelessWidget {
  final TabController tabController;

  AgendaPage(this.tabController);

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.agenda,
      child: StoreConnector<AppState, AgendaPageViewModel>(
        onInit: (store) => store.dispatch(AgendaRequestAction(DateTime.now())),
        builder: (context, viewModel) => _Scaffold(viewModel: viewModel, tabController: tabController),
        converter: (store) => AgendaPageViewModel.create(store),
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  final AgendaPageViewModel viewModel;
  final TabController tabController;

  const _Scaffold({Key? key, required this.viewModel, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Stack(children: [
        DefaultAnimatedSwitcher(child: _Body(viewModel: viewModel, tabController: tabController)),
        _CreateActionButton(resetCreateAction: viewModel.resetCreateAction),
      ]),
    );
  }
}

class _CreateActionButton extends StatelessWidget {
  final Function() resetCreateAction;

  _CreateActionButton({required this.resetCreateAction});

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
          ).then((value) => {resetCreateAction()}),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final AgendaPageViewModel viewModel;
  final TabController tabController;

  const _Body({Key? key, required this.viewModel, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (viewModel.displayState) {
      case DisplayState.LOADING:
        return Center(child: CircularProgressIndicator());
      case DisplayState.CONTENT:
        return _Content(viewModel: viewModel, tabController: tabController);
      case DisplayState.EMPTY:
        return _Empty();
      case DisplayState.FAILURE:
        return _Retry(viewModel: viewModel);
    }
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Margins.spacing_l),
          Flexible(child: SvgPicture.asset(Drawables.icEmptyOffres)),
          SizedBox(height: Margins.spacing_l),
          Text(Strings.agendaEmpty, style: TextStyles.textBaseRegular, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Retry extends StatelessWidget {
  final AgendaPageViewModel viewModel;

  const _Retry({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Retry(Strings.agendaError, () => viewModel.retry(DateTime.now())),
    ));
  }
}

class _Content extends StatelessWidget {
  final AgendaPageViewModel viewModel;
  final TabController tabController;

  const _Content({Key? key, required this.viewModel, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: Margins.spacing_base, bottom: 96),
        itemCount: viewModel.events.length,
        itemBuilder: (context, index) {
          final item = viewModel.events[index];
          if (item is DelayedActionsBanner) return _DelayedActionsBanner(item, tabController);
          if (item is CurrentWeekAgendaItem) return _CurrentWeek(item.days);
          if (item is NextWeekAgendaItem) return _NextWeek(item.events);
          return SizedBox(height: 0);
        },
      ),
    );
  }
}

class _DelayedActionsBanner extends StatelessWidget {
  final DelayedActionsBanner banner;
  final TabController tabController;

  _DelayedActionsBanner(this.banner, this.tabController);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [Shadows.boxShadow]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => tabController.animateTo(1),
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _WarningIcon(),
                  _NumberOfDelayedActions(banner.count),
                  Text(Strings.see, style: TextStyles.textBaseRegular),
                  _ChevronIcon(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WarningIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SvgPicture.asset(Drawables.icImportantOutlined, color: AppColors.warning, height: 20),
    );
  }
}

class _ChevronIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SvgPicture.asset(Drawables.icChevronRight, color: AppColors.contentColor),
    );
  }
}

class _NumberOfDelayedActions extends StatelessWidget {
  final int actions;

  _NumberOfDelayedActions(this.actions);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: Strings.late, style: TextStyles.textBaseBoldWithColor(AppColors.warning)),
            TextSpan(text: Strings.numberOfActions(actions), style: TextStyles.textSRegularWithColor(AppColors.warning))
          ],
        ),
      ),
    );
  }
}

class _CurrentWeek extends StatelessWidget {
  final List<DaySectionAgenda> days;

  _CurrentWeek(this.days);

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return Text("TODO les deux labels Semaine courante vide");
    }
    return Column(children: days.map((e) => _DaySection(e)).toList());
  }
}

class _NextWeek extends StatelessWidget {
  final List<EventAgenda> events;

  _NextWeek(this.events);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: Margins.spacing_m, bottom: Margins.spacing_s),
          child: BigTitleSeparator(Strings.nextWeek),
        ),
        if (events.isEmpty) Text("TODO le label semaine prochaine vide"),
        if (events.isNotEmpty) ...events.widgets(context),
      ],
    );
  }
}

class _DaySection extends StatelessWidget {
  final DaySectionAgenda section;

  _DaySection(this.section);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DaySectionTitle(section.title),
        ...section.events.widgets(context),
      ],
    );
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
    return map((event) => event.widget(context)).toList();
  }
}

extension _EventWidget on EventAgenda {
  Widget widget(BuildContext context) {
    final event = this;
    if (event is UserActionEventAgenda) {
      return _ActionCard(id: event.id);
    } else if (event is RendezvousEventAgenda) {
      return event.rendezvousCard(context);
    } else {
      return SizedBox(height: 0);
    }
  }
}

extension _RendezvousCard on RendezvousEventAgenda {
  Widget rendezvousCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      child: RendezvousCard(
        converter: (store) => RendezvousCardViewModel.createFromAgendaState(store, id),
        onTap: () {
          context.trackEvent(EventType.RDV_DETAIL);
          Navigator.push(
            context,
            RendezvousDetailsPage.materialPageRouteWithAgendaState(id),
          );
        },
      ),
    );
  }
}

// todo Refactoring (low) : mutualiser, onTap en param ?

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      child: UserActionCard(
        onTap: () {
          context.trackEvent(EventType.ACTION_DETAIL);
          Navigator.push(
            context,
            UserActionDetailPage.materialPageRoute(viewModel, StateSource.agenda),
          );
        },
        viewModel: viewModel,
      ),
    );
  }
}
