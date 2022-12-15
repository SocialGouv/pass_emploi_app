import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step1_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_detail_page.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
import 'package:pass_emploi_app/presentation/agenda/agenda_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/big_title_separator.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/user_action_create_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/demarche_card.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/cards/user_action_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/empty_page.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class AgendaPage extends StatelessWidget {
  final Function() onActionDelayedTap;

  AgendaPage(this.onActionDelayedTap);

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.agenda,
      child: StoreConnector<AppState, AgendaPageViewModel>(
        onInit: (store) => store.dispatch(AgendaRequestAction(DateTime.now())),
        builder: (context, viewModel) => _Scaffold(viewModel: viewModel, onActionDelayedTap: onActionDelayedTap),
        converter: (store) => AgendaPageViewModel.create(store),
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  final AgendaPageViewModel viewModel;
  final Function() onActionDelayedTap;

  const _Scaffold({Key? key, required this.viewModel, required this.onActionDelayedTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Stack(children: [
        DefaultAnimatedSwitcher(child: _Body(viewModel: viewModel, onActionDelayedTap: onActionDelayedTap)),
        if (viewModel.createButton == CreateButton.userAction)
          _CreateButton(
            label: Strings.addAnAction,
            onPressed: () => showPassEmploiBottomSheet(
              context: context,
              builder: (context) => CreateUserActionBottomSheet(),
            ).then((value) => viewModel.resetCreateAction()),
          ),
        if (viewModel.createButton == CreateButton.demarche)
          _CreateButton(
            label: Strings.addADemarche,
            onPressed: () => Navigator.push(context, CreateDemarcheStep1Page.materialPageRoute())
                .then((value) => viewModel.reload(DateTime.now())),
          ),
      ]),
    );
  }
}

class _CreateButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _CreateButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: PrimaryActionButton(
          label: label,
          drawableRes: Drawables.icAdd,
          rippleColor: AppColors.primaryDarken,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final AgendaPageViewModel viewModel;
  final Function() onActionDelayedTap;

  const _Body({Key? key, required this.viewModel, required this.onActionDelayedTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (viewModel.displayState) {
      case DisplayState.LOADING:
        return Center(child: CircularProgressIndicator());
      case DisplayState.CONTENT:
        return _Content(viewModel: viewModel, onActionDelayedTap: onActionDelayedTap);
      case DisplayState.EMPTY:
        return Empty(description: viewModel.emptyMessage);
      case DisplayState.FAILURE:
        return _Retry(viewModel: viewModel);
    }
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
      child: Retry(Strings.agendaError, () => viewModel.reload(DateTime.now())),
    ));
  }
}

class _Content extends StatelessWidget {
  final AgendaPageViewModel viewModel;
  final Function() onActionDelayedTap;

  const _Content({Key? key, required this.viewModel, required this.onActionDelayedTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: Margins.spacing_base, bottom: 120),
        itemCount: viewModel.events.length,
        itemBuilder: (context, index) {
          final item = viewModel.events[index];
          if (item is DelayedActionsBannerAgendaItem) return _DelayedActionsBanner(item, onActionDelayedTap);
          if (item is CurrentWeekAgendaItem) return _CurrentWeek(item.days, viewModel.noEventLabel);
          if (item is NextWeekAgendaItem) return _NextWeek(item.events, viewModel.noEventLabel);
          return SizedBox(height: 0);
        },
      ),
    );
  }
}

class _DelayedActionsBanner extends StatelessWidget {
  final DelayedActionsBannerAgendaItem banner;
  final Function() onActionDelayedTap;

  _DelayedActionsBanner(this.banner, this.onActionDelayedTap);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: onActionDelayedTap,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _WarningIcon(),
          _NumberOfDelayedActions(banner.delayedLabel),
          Text(Strings.see, style: TextStyles.textBaseRegular),
          _ChevronIcon(),
        ],
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
  final String delayedLabel;

  _NumberOfDelayedActions(this.delayedLabel);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: Strings.late, style: TextStyles.textBaseBoldWithColor(AppColors.warning)),
            TextSpan(text: delayedLabel, style: TextStyles.textSRegularWithColor(AppColors.warning))
          ],
        ),
      ),
    );
  }
}

class _CurrentWeek extends StatelessWidget {
  final List<DaySectionAgenda> days;
  final String noEventLabel;

  _CurrentWeek(this.days, this.noEventLabel);

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty || 1 == 1) {
      // FIXME: enlever
      return _CurrentWeekEmptyCard(noEventLabel);
    }
    return Column(children: days.map((e) => _DaySection(e, noEventLabel)).toList());
  }
}

class _CurrentWeekEmptyCard extends StatelessWidget {
  final String noEventLabel;

  const _CurrentWeekEmptyCard(this.noEventLabel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_base),
      child: CardContainer(
          child: Column(
        children: [
          Text(
            Strings.agendaNoActionThisWeekTitle,
            style: TextStyles.textMBold,
          ),
          SizedBox(height: 10),
          Text(
            Strings.agendaNoActionThisWeekDescription,
            style: TextStyles.textBaseRegular,
          ),
          SizedBox(height: 10),
          TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () {
                // TODO:
                // StoreProvider.of<AppState>(context).dispatch();
              },
              child: Row(
                children: [
                  Text(
                    Strings.agendaSeeEventInAgenceButton,
                    style: TextStyles.textBaseUnderline,
                  ),
                  SizedBox(width: 10),
                  SvgPicture.asset(Drawables.icChevronRight, color: AppColors.primary),
                ],
              ))
        ],
      )),
    );
  }
}

class _NextWeek extends StatelessWidget {
  final List<EventAgenda> events;
  final String noEventLabel;

  _NextWeek(this.events, this.noEventLabel);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: Margins.spacing_m, bottom: Margins.spacing_s),
          child: BigTitleSeparator(Strings.nextWeek),
        ),
        if (events.isEmpty) _NoEventTitle(noEventLabel),
        if (events.isNotEmpty) ...events.widgets(context: context, simpleCard: true),
      ],
    );
  }
}

class _DaySection extends StatelessWidget {
  final DaySectionAgenda section;
  final String noEventLabel;

  _DaySection(this.section, this.noEventLabel);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(section.title),
        if (section.events.isNotEmpty) ...section.events.widgets(context: context, simpleCard: false),
        if (section.events.isEmpty) _NoEventTitle(noEventLabel),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  _SectionTitle(this.title);

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

class _NoEventTitle extends StatelessWidget {
  final String label;

  const _NoEventTitle(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyles.textBaseRegularWithColor(AppColors.grey700),
    );
  }
}

extension _EventWidgets on List<EventAgenda> {
  List<Widget> widgets({required BuildContext context, required bool simpleCard}) {
    return map((event) => event.widget(context, simpleCard)).toList();
  }
}

extension _EventWidget on EventAgenda {
  Widget widget(BuildContext context, bool simpleCard) {
    final event = this;
    if (event is UserActionEventAgenda) {
      return event.agendaCard(context, simpleCard);
    } else if (event is DemarcheEventAgenda) {
      return event.demarcheCard(context, simpleCard);
    } else if (event is RendezvousEventAgenda) {
      return event.rendezvousCard(context, simpleCard);
    } else {
      return SizedBox(height: 0);
    }
  }
}

extension _ActionCard on UserActionEventAgenda {
  Widget agendaCard(BuildContext context, bool simpleCard) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      child: UserActionCard(
        userActionId: id,
        stateSource: UserActionStateSource.agenda,
        simpleCard: simpleCard,
        onTap: () {
          context.trackEvent(EventType.ACTION_DETAIL);
          Navigator.push(
            context,
            UserActionDetailPage.materialPageRoute(id, UserActionStateSource.agenda),
          );
        },
      ),
    );
  }
}

extension _DemarcheCard on DemarcheEventAgenda {
  Widget demarcheCard(BuildContext context, bool simpleCard) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      child: DemarcheCard(
        demarcheId: id,
        stateSource: DemarcheStateSource.agenda,
        simpleCard: simpleCard,
        onTap: () {
          context.trackEvent(EventType.ACTION_DETAIL);
          Navigator.push(
            context,
            DemarcheDetailPage.materialPageRoute(id, DemarcheStateSource.agenda),
          );
        },
      ),
    );
  }
}

extension _RendezvousCard on RendezvousEventAgenda {
  Widget rendezvousCard(BuildContext context, bool simpleCard) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      child: id.rendezvousCard(
        context: context,
        stateSource: RendezvousStateSource.agenda,
        trackedEvent: EventType.RDV_DETAIL,
        simpleCard: simpleCard,
      ),
    );
  }
}
