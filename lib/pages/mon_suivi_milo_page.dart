import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_page.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/mon_suivi/mon_suivi_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/animated_list_loader.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/cards/user_action_card.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/dashed_box.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:shimmer/shimmer.dart';

final _key = GlobalKey();
final Map<GlobalKey, MonSuiviDay> _dayKeys = {};

final ScrollController _scrollController = ScrollController();

class MonSuiviMiloPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.monSuiviMilo,
      child: StoreConnector<AppState, MonSuiviViewModel>(
        onInit: (store) => store.dispatch(MonSuiviRequestAction(MonSuiviPeriod.current)),
        converter: (store) => MonSuiviViewModel.create(store),
        builder: (_, viewModel) => _Scaffold(body: _Body(viewModel), withCreateButton: viewModel.withCreateButton),
        onDispose: (store) => store.dispatch(MonSuiviResetAction()),
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  final Widget body;
  final bool withCreateButton;

  const _Scaffold({required this.body, required this.withCreateButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: PrimaryAppBar(title: Strings.monSuiviAppBarTitle),
      body: ConnectivityContainer(child: body),
      floatingActionButton: Visibility(
        visible: withCreateButton,
        child: PrimaryActionButton(
          label: Strings.addAnAction,
          icon: AppIcons.add_rounded,
          rippleColor: AppColors.primaryDarken,
          onPressed: () => CreateUserActionFormPage.pushUserActionCreationTunnel(
            context,
            UserActionStateSource.monSuivi,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _Body extends StatelessWidget {
  final MonSuiviViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AnimationDurations.fast,
      child: switch (viewModel.displayState) {
        DisplayState.FAILURE => Center(child: Retry(Strings.monSuiviError, () => viewModel.onRetry())),
        DisplayState.CONTENT => _Stack(viewModel),
        _ => _MonSuiviLoader(),
      },
    );
  }
}

class _Stack extends StatelessWidget {
  final MonSuiviViewModel viewModel;

  const _Stack(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _TodayCenteredMonSuiviList(viewModel),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: _DayOverlay(),
        ),
      ],
    );
  }
}

class _TodayCenteredMonSuiviList extends StatelessWidget {
  final MonSuiviViewModel viewModel;
  final List<MonSuiviItem> pastItems;
  final List<MonSuiviItem> presentAndFutureItems;

  _TodayCenteredMonSuiviList(this.viewModel)
      : pastItems = viewModel.items.sublist(0, viewModel.indexOfTodayItem).reversed.toList(),
        presentAndFutureItems = viewModel.items.sublist(viewModel.indexOfTodayItem);

  @override
  Widget build(BuildContext context) {
    bool loadingPreviousPeriod = false;
    bool loadingNextPeriod = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: CustomScrollView(
        controller: _scrollController,
        center: _key,
        slivers: [
          SliverList.separated(
            separatorBuilder: (context, index) => const SizedBox(height: Margins.spacing_base),
            itemCount: pastItems.length + 1,
            itemBuilder: (context, index) {
              if (index > pastItems.length - 2 && !loadingPreviousPeriod) {
                viewModel.onLoadPreviousPeriod();
                loadingPreviousPeriod = true;
              }
              if (index == pastItems.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: Margins.spacing_base),
                  child: _PaginationLoader(),
                );
              }
              return pastItems[index].toWidget();
            },
          ),
          SliverList.separated(
            key: _key,
            separatorBuilder: (context, index) => const SizedBox(height: Margins.spacing_base),
            itemCount: presentAndFutureItems.length + 1,
            itemBuilder: (context, index) {
              if (index > presentAndFutureItems.length - 2 && !loadingNextPeriod) {
                viewModel.onLoadNextPeriod();
                loadingNextPeriod = true;
              }
              if (index == presentAndFutureItems.length) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Margins.spacing_base),
                  child: _PaginationLoader(),
                );
              }
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? Margins.spacing_base : 0),
                child: presentAndFutureItems[index].toWidget(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SemaineSectionItem extends StatelessWidget {
  final String interval;
  final String? boldTitle;

  const _SemaineSectionItem(this.interval, this.boldTitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (boldTitle != null) ...[
            Text(boldTitle!, style: TextStyles.textMBold),
            const SizedBox(height: Margins.spacing_xs),
          ],
          Text(interval, style: TextStyles.textXsRegular(color: AppColors.grey800)),
        ],
      ),
    );
  }
}

class _FilledDayItem extends StatelessWidget {
  final MonSuiviDay day;
  final List<MonSuiviEntry> entries;

  const _FilledDayItem(this.day, this.entries);

  @override
  Widget build(BuildContext context) {
    final GlobalKey key = GlobalKey();
    _dayKeys[key] = day;
    return _DayRow(
      key: key,
      day: day,
      child: Column(
        children: entries //
            .map((entry) => [entry.toWidget(), SizedBox(height: Margins.spacing_s)])
            .flattened
            .toList()
          ..removeLast(),
      ),
    );
  }
}

class _EmptyDayItem extends StatelessWidget {
  final MonSuiviDay day;

  const _EmptyDayItem(this.day);

  @override
  Widget build(BuildContext context) {
    return _DayRow(
      day: day,
      child: DashedBox(
        padding: const EdgeInsets.all(Margins.spacing_base),
        color: AppColors.disabled,
        child: Text(Strings.monSuiviEmptyDay, style: TextStyles.textXsMedium(color: AppColors.disabled)),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  final MonSuiviDay day;
  final Widget child;

  const _DayRow({super.key, required this.day, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _Day(day)),
        const SizedBox(width: Margins.spacing_base),
        Expanded(flex: 9, child: child),
      ],
    );
  }
}

class _Day extends StatelessWidget {
  final MonSuiviDay day;

  const _Day(this.day);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.grey100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(day.shortened, style: TextStyles.textXsMedium()),
          Text(day.number, style: TextStyles.textBaseBold),
        ],
      ),
    );
  }
}

class _UserActionMonSuiviItem extends StatelessWidget {
  final UserActionMonSuiviEntry entry;

  const _UserActionMonSuiviItem(this.entry);

  @override
  Widget build(BuildContext context) {
    return UserActionCard(
      userActionId: entry.id,
      stateSource: UserActionStateSource.monSuivi,
      onTap: () {
        context.trackEvent(EventType.ACTION_DETAIL);
        Navigator.push(
          context,
          UserActionDetailPage.materialPageRoute(entry.id, UserActionStateSource.monSuivi),
        );
      },
    );
  }
}

class _RendezvousMonSuiviItem extends StatelessWidget {
  final RendezvousMonSuiviEntry entry;

  const _RendezvousMonSuiviItem(this.entry);

  @override
  Widget build(BuildContext context) {
    return entry.id.rendezvousCard(
      context: context,
      stateSource: RendezvousStateSource.monSuivi,
      trackedEvent: EventType.RDV_DETAIL,
    );
  }
}

class _SessionMiloMonSuiviItem extends StatelessWidget {
  final SessionMiloMonSuiviEntry entry;

  const _SessionMiloMonSuiviItem(this.entry);

  @override
  Widget build(BuildContext context) {
    return entry.id.rendezvousCard(
      context: context,
      stateSource: RendezvousStateSource.monSuiviSessionMilo,
      trackedEvent: EventType.RDV_DETAIL,
    );
  }
}

class _MonSuiviLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedListLoader(
      placeholders: [
        ..._dayItems((7 - DateTime.now().weekday) + 1),
        ..._semaineSection(screenWidth),
        ..._dayItems(7),
        ..._semaineSection(screenWidth),
      ],
    );
  }

  List<Widget> _dayItems(int count) {
    return [
      for (var i = 0; i < count; ++i)
        Padding(
          padding: EdgeInsets.only(top: Margins.spacing_base),
          child: _MonSuiviItemLoader(),
        )
    ];
  }

  List<Widget> _semaineSection(double screenWidth) {
    return [
      SizedBox(height: Margins.spacing_m),
      AnimatedListLoader.placeholderBuilder(width: screenWidth * 0.5, height: 24),
      SizedBox(height: Margins.spacing_s),
      AnimatedListLoader.placeholderBuilder(width: screenWidth * 0.3, height: 16),
      SizedBox(height: Margins.spacing_s),
    ];
  }
}

class _PaginationLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.loadingGreyPlaceholder,
      highlightColor: Colors.white,
      child: _MonSuiviItemLoader(),
    );
  }
}

class _MonSuiviItemLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: AnimatedListLoader.placeholderBuilder(width: screenWidth, height: 40)),
        const SizedBox(width: Margins.spacing_base),
        Expanded(
          flex: 9,
          child: AnimatedListLoader.placeholderBuilder(width: screenWidth, height: 56),
        ),
      ],
    );
  }
}

extension on MonSuiviItem {
  Widget toWidget() {
    return switch (this) {
      final SemaineSectionMonSuiviItem item => _SemaineSectionItem(item.interval, item.boldTitle),
      final EmptyDayMonSuiviItem item => _EmptyDayItem(item.day),
      final FilledDayMonSuiviItem item => _FilledDayItem(item.day, item.entries),
    };
  }
}

extension on MonSuiviEntry {
  Widget toWidget() {
    return switch (this) {
      final UserActionMonSuiviEntry entry => _UserActionMonSuiviItem(entry),
      final RendezvousMonSuiviEntry entry => _RendezvousMonSuiviItem(entry),
      final SessionMiloMonSuiviEntry entry => _SessionMiloMonSuiviItem(entry),
    };
  }
}

class _DayOverlay extends StatefulWidget {
  @override
  State<_DayOverlay> createState() => _DayOverlayState();
}

class _DayOverlayState extends State<_DayOverlay> {
  //MonSuiviDay? _day;
  Widget _child = const SizedBox();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  BAS  & Row > Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(animation),
    //  BAS  & SB  > Rien
    //  Haut & Row >
    //  Haut & SB  >

    return AnimatedSwitcher(
      duration: Durations.short3,
      transitionBuilder: (child, animation) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(animation),
        child: child,
      ),
      child: _child,
    );
  }

  void _scrollListener() {
    MonSuiviDay? day;
    for (var key in _dayKeys.keys) {
      final RenderObject? box = key.currentContext?.findRenderObject();
      if (box != null) {
        final MonSuiviDay? day2 = _dayKeys[key];
        final shouldBeVisible = _shouldBeVisible(box, day2 == MonSuiviDay.fromDateTime(DateTime.now()));
        if (shouldBeVisible) {
          day = day2;
          break;
        }
      }
    }
    final Widget widget = toWidget(day);
    if (widget.runtimeType != _child.runtimeType) {
      setState(() => _child = widget);
    } else if (widget is _DayRow && _child is _DayRow) {
      if (widget.day != (_child as _DayRow).day) {
        setState(() => _child = widget);
      }
    }
  }

  Widget toWidget(MonSuiviDay? day) {
    return day != null ? _DayRow(day: day, child: const SizedBox()) : const SizedBox();
  }

  bool _shouldBeVisible(RenderObject? box, bool withExtraPadding) {
    if (box != null) {
      const double toolbarHeight = 139.81;
      const extraTopPaddingForTodayElement = 16.0;
      final renderBox = (box as RenderBox);
      final double yPosition = renderBox.localToGlobal(Offset.zero).dy - toolbarHeight + extraTopPaddingForTodayElement;
      //print('### Widget is visible in the viewport at position: $yPosition');
      //print('### Widget is visible in the viewport at position: ${renderBox.size.height}');

      //shouldBeVisible = yPosition < 0 && yPosition > -renderBox.size.height - extraTopPaddingForTodayElement;
      return yPosition < 0 && yPosition > -renderBox.size.height + 16 + extraTopPaddingForTodayElement;

      // do stuff...
    } else {
      //print('### Widget is not visible.');
      return false;
      // do stuff...
    }
  }
}
