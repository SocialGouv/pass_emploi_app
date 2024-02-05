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
import 'package:pass_emploi_app/widgets/cards/user_actions_pending_card.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/dashed_box.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:shimmer/shimmer.dart';

final GlobalKey _key = GlobalKey();
final GlobalKey _stackKey = GlobalKey();
final ScrollController _scrollController = ScrollController();
final Map<GlobalKey, MonSuiviDay> _filledDayItemKeys = {};

GlobalKey? _randomDayKey;
double? _dayOverlayHeight;

class MonSuiviMiloPage extends StatefulWidget {
  @override
  State<MonSuiviMiloPage> createState() => _MonSuiviMiloPageState();
}

class _MonSuiviMiloPageState extends State<MonSuiviMiloPage> {
  @override
  void dispose() {
    _filledDayItemKeys.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.monSuiviV2,
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
    return PrimaryAppBar(
      title: Strings.monSuiviAppBarTitle,
      actionButton: withActionButton
          ? IconButton(
              onPressed: () => _scrollController.animateTo(
                0,
                duration: AnimationDurations.fast,
                curve: Curves.fastEaseInToSlowEaseOut,
              ),
              icon: Icon(AppIcons.event, color: AppColors.primary),
              tooltip: Strings.monSuiviTooltip,
            )
          : null,
    );
  }

  void _scrollListener() {
    if (_scrollController.offset != 0) {
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
        if (viewModel.pendingActionCreations > 0)
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_s, left: Margins.spacing_s, right: Margins.spacing_s),
            child: UserActionsPendingCard(viewModel.pendingActionCreations),
          ),
        Expanded(
          child: Stack(
            key: _stackKey,
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
        center: _key,
        controller: _scrollController,
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
    _filledDayItemKeys[key] = day;
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
    final bool addKey = _randomDayKey == null;
    if (addKey) _randomDayKey = GlobalKey();

    return ColoredBox(
      key: addKey ? _randomDayKey : null,
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
    return _day != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
            child: _DayRow(day: _day!, child: const SizedBox()),
          )
        : SizedBox();
  }

  void _scrollListener() {
    if (_scrollController.offset == 0 && _day != null) setState(() => _day = null);

    final MonSuiviDay? day = _overlayDay();
    if (day != _day) setState(() => _day = day);
  }

  MonSuiviDay? _overlayDay() {
    MonSuiviDay? overlayDay;
    for (var key in _filledDayItemKeys.keys) {
      final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) continue;

      final MonSuiviDay boxDay = _filledDayItemKeys[key]!;
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

    final ancestor = _stackKey.currentContext?.findRenderObject();
    final double renderBoxY = renderBox.localToGlobal(Offset.zero, ancestor: ancestor).dy;
    final isRenderBoxTopVisible = renderBoxY >= 0;
    final isRenderBoxOnScreen = renderBoxY > -renderBox.size.height + overlayHeight;
    return !isRenderBoxTopVisible && isRenderBoxOnScreen;
  }

  double? _getOverlayHeight() {
    if (_dayOverlayHeight == null) {
      final RenderBox? randomDayBox = _randomDayKey?.currentContext?.findRenderObject() as RenderBox?;
      if (randomDayBox == null) return null;
      _dayOverlayHeight = randomDayBox.size.height;
    }
    return _dayOverlayHeight;
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
