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
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/animated_list_loader.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/onboarding/onboarding_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/cards/user_action_card.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/dashed_box.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:shimmer/shimmer.dart';

class MonSuiviMiloPage extends StatefulWidget {
  @override
  State<MonSuiviMiloPage> createState() => _MonSuiviMiloPageState();
}

class _MonSuiviMiloPageState extends State<MonSuiviMiloPage> {
  bool _onboardingShown = false;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.monSuiviV2,
      child: _StateProvider(
        child: StoreConnector<AppState, MonSuiviViewModel>(
          onInit: (store) => store.dispatch(MonSuiviRequestAction(MonSuiviPeriod.current)),
          converter: (store) => MonSuiviViewModel.create(store),
          builder: (_, viewModel) => _Scaffold(body: _Body(viewModel), withCreateButton: viewModel.withCreateButton),
          onDispose: (store) => store.dispatch(MonSuiviResetAction()),
          onDidChange: (_, viewModel) => _handleOnboarding(context, viewModel),
          distinct: true,
        ),
      ),
    );
  }

  void _handleOnboarding(BuildContext context, MonSuiviViewModel viewModel) {
    if (viewModel.shouldShowOnboarding && !_onboardingShown) {
      _onboardingShown = true;
      OnboardingBottomSheet.show(context, source: OnboardingSource.monSuivi);
    }
  }
}

//ignore: must_be_immutable
class _StateProvider extends InheritedWidget {
  final GlobalKey centerKey = GlobalKey();
  final GlobalKey contentKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  final Map<GlobalKey, MonSuiviDay> filledDayItemKeys = {};
  GlobalKey? randomDayKey;
  double? dayOverlayHeight;
  int previousPeriodCount = 0;
  int nextPeriodCount = 0;

  _StateProvider({required super.child});

  static _StateProvider? maybeOf(BuildContext context) => context.dependOnInheritedWidgetOfExactType<_StateProvider>();

  @override
  bool updateShouldNotify(_StateProvider old) => false;
}

class _Scaffold extends StatelessWidget {
  final Widget body;
  final bool withCreateButton;

  const _Scaffold({required this.body, required this.withCreateButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: _ScrollAwareAppBar(),
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

class _ScrollAwareAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<_ScrollAwareAppBar> createState() => _ScrollAwareAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(PrimaryAppBar.toolBarHeight);
}

class _ScrollAwareAppBarState extends State<_ScrollAwareAppBar> {
  bool withActionButton = false;

  @override
  void didChangeDependencies() {
    _StateProvider.maybeOf(context)?.scrollController.addListener(_scrollListener);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryAppBar(
      title: Strings.monSuiviAppBarTitle,
      actionButton: withActionButton
          ? IconButton(
        onPressed: () => _StateProvider.maybeOf(context)?.scrollController.animateTo(
                    0,
                    duration: AnimationDurations.fast,
                    curve: Curves.fastEaseInToSlowEaseOut,
                  ),
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  AppIcons.event,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              tooltip: Strings.monSuiviTooltip,
            )
          : null,
    );
  }

  void _scrollListener() {
    if (_StateProvider.maybeOf(context)?.scrollController.offset != 0) {
      if (!withActionButton) setState(() => withActionButton = true);
    } else {
      if (withActionButton) setState(() => withActionButton = false);
    }
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
        DisplayState.CONTENT => _Content(viewModel),
        _ => _MonSuiviLoader(),
      },
    );
  }
}

class _Content extends StatelessWidget {
  final MonSuiviViewModel viewModel;

  const _Content(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (viewModel.withWarningOnWrongSessionMiloRetrieval) ...[
          SizedBox(height: Margins.spacing_s),
          _SessionMiloWarningCard(viewModel),
        ],
        if (viewModel.pendingActionCreations > 0) ...[
          SizedBox(height: Margins.spacing_s),
          _UserActionsPendingCard(viewModel.pendingActionCreations),
        ],
        Expanded(
          child: Stack(
            key: _StateProvider.maybeOf(context)?.contentKey,
            children: [
              _TodayCenteredMonSuiviList(viewModel),
              _DayOverlay(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SessionMiloWarningCard extends StatelessWidget {
  final MonSuiviViewModel viewModel;

  const _SessionMiloWarningCard(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_s),
      child: CardContainer(
        backgroundColor: AppColors.disabled,
        padding: EdgeInsets.zero, // Padding is set in row children because of inner padding of OutlinedButton
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: Margins.spacing_base),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Margins.spacing_base),
              child: Icon(AppIcons.error_rounded, color: Colors.white),
            ),
            SizedBox(width: Margins.spacing_s),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Margins.spacing_base),
                child: Text(Strings.monSuiviSessionMiloError, style: TextStyles.textXsRegular(color: Colors.white)),
              ),
            ),
            OutlinedButton(
              onPressed: () => viewModel.onRetry(),
              child: Text(Strings.retry, style: TextStyles.textSBoldWithColor(Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserActionsPendingCard extends StatelessWidget {
  final int userActionsPostponedCount;

  const _UserActionsPendingCard(this.userActionsPostponedCount);

  @override
  Widget build(BuildContext context) {
    final message = userActionsPostponedCount > 1
        ? Strings.pendingActionCreationPlural(userActionsPostponedCount)
        : Strings.pendingActionCreationSingular;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_s),
      child: CardContainer(
        backgroundColor: AppColors.disabled,
        child: Row(
          children: [
            Icon(AppIcons.error_rounded, color: Colors.white),
            SizedBox(width: Margins.spacing_s),
            Flexible(child: Text(message, style: TextStyles.textXsRegular(color: Colors.white))),
          ],
        ),
      ),
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
        center: _StateProvider.maybeOf(context)?.centerKey,
        controller: _StateProvider.maybeOf(context)?.scrollController,
        slivers: [
          SliverList.separated(
            separatorBuilder: (context, index) => const SizedBox(height: Margins.spacing_base),
            itemCount: pastItems.length + 1,
            itemBuilder: (context, index) {
              if (index > pastItems.length - 2 && !loadingPreviousPeriod) {
                viewModel.onLoadPreviousPeriod();
                loadingPreviousPeriod = true;

                _StateProvider.maybeOf(context)?.previousPeriodCount--;
                PassEmploiMatomoTracker.instance.trackEvent(
                  eventCategory: AnalyticsEventNames.monSuiviV2Category,
                  action: AnalyticsEventNames.monSuiviV2PreviousPeriodAction,
                  eventName: AnalyticsEventNames.monSuiviV2PeriodName,
                  eventValue: _StateProvider.maybeOf(context)?.previousPeriodCount,
                );
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
            key: _StateProvider.maybeOf(context)?.centerKey,
            separatorBuilder: (context, index) => const SizedBox(height: Margins.spacing_base),
            itemCount: presentAndFutureItems.length + 1,
            itemBuilder: (context, index) {
              if (index > presentAndFutureItems.length - 2 && !loadingNextPeriod) {
                viewModel.onLoadNextPeriod();
                loadingNextPeriod = true;

                _StateProvider.maybeOf(context)?.nextPeriodCount++;
                PassEmploiMatomoTracker.instance.trackEvent(
                  eventCategory: AnalyticsEventNames.monSuiviV2Category,
                  action: AnalyticsEventNames.monSuiviV2NextPeriodAction,
                  eventName: AnalyticsEventNames.monSuiviV2PeriodName,
                  eventValue: _StateProvider.maybeOf(context)?.nextPeriodCount,
                );
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
    _StateProvider.maybeOf(context)?.filledDayItemKeys[key] = day;
    return _DayRow(
      day: day,
      child: Column(
        key: key,
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
  final String text;

  const _EmptyDayItem(this.day, this.text);

  @override
  Widget build(BuildContext context) {
    return _DayRow(
      day: day,
      child: DashedBox(
        padding: const EdgeInsets.all(Margins.spacing_base),
        color: AppColors.disabled,
        child: Text(text, style: TextStyles.textXsMedium(color: AppColors.disabled)),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  final MonSuiviDay day;
  final Widget child;

  const _DayRow({required this.day, required this.child});

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
    final bool addKey = _StateProvider.maybeOf(context)?.randomDayKey == null;
    if (addKey) _StateProvider.maybeOf(context)?.randomDayKey = GlobalKey();

    return ColoredBox(
      key: addKey ? _StateProvider.maybeOf(context)?.randomDayKey : null,
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
      source: UserActionStateSource.monSuivi,
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

class _DayOverlay extends StatefulWidget {
  @override
  State<_DayOverlay> createState() => _DayOverlayState();
}

class _DayOverlayState extends State<_DayOverlay> {
  MonSuiviDay? _day;

  @override
  void didChangeDependencies() {
    _StateProvider.maybeOf(context)?.scrollController.addListener(_scrollListener);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _day != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
            child: _DayRow(day: _day!, child: const SizedBox()),
          )
        : SizedBox();
  }

  void _scrollListener() {
    if (_StateProvider.maybeOf(context)?.scrollController.offset == 0 && _day != null) setState(() => _day = null);

    final MonSuiviDay? day = _overlayDay();
    if (day != _day) setState(() => _day = day);
  }

  MonSuiviDay? _overlayDay() {
    MonSuiviDay? overlayDay;
    final filledDayItemKeys = _StateProvider.maybeOf(context)?.filledDayItemKeys ?? {};
    for (var key in filledDayItemKeys.keys) {
      final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) continue;

      final MonSuiviDay? boxDay = filledDayItemKeys[key];
      if (boxDay == null) continue;

      final overlayShouldBeVisible = _overlayShouldBeVisible(renderBox);
      if (overlayShouldBeVisible) {
        overlayDay = boxDay;
        break;
      }
    }
    return overlayDay;
  }

  bool _overlayShouldBeVisible(RenderBox renderBox) {
    final overlayHeight = _getOverlayHeight();
    if (overlayHeight == null) return false;

    final ancestor = _StateProvider.maybeOf(context)?.contentKey.currentContext?.findRenderObject();
    final double renderBoxY = renderBox.localToGlobal(Offset.zero, ancestor: ancestor).dy;
    final isRenderBoxTopVisible = renderBoxY >= 0;
    final isRenderBoxOnScreen = renderBoxY > -renderBox.size.height + overlayHeight;
    return !isRenderBoxTopVisible && isRenderBoxOnScreen;
  }

  double? _getOverlayHeight() {
    if (_StateProvider.maybeOf(context)?.dayOverlayHeight == null) {
      final RenderBox? randomDayBox =
          _StateProvider.maybeOf(context)?.randomDayKey?.currentContext?.findRenderObject() as RenderBox?;
      if (randomDayBox == null) return null;
      _StateProvider.maybeOf(context)?.dayOverlayHeight = randomDayBox.size.height;
    }
    return _StateProvider.maybeOf(context)?.dayOverlayHeight;
  }
}

extension on MonSuiviItem {
  Widget toWidget() {
    return switch (this) {
      final SemaineSectionMonSuiviItem item => _SemaineSectionItem(item.interval, item.boldTitle),
      final EmptyDayMonSuiviItem item => _EmptyDayItem(item.day, item.text),
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
