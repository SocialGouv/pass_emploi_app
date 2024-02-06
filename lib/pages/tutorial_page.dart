import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/tutorial_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/primary_rounded_bottom_background.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialPage extends StatefulWidget {
  @override
  State<TutorialPage> createState() => _TutorialPageState();

  static MaterialPageRoute<bool> materialPageRoute() {
    return MaterialPageRoute(builder: (_) => TutorialPage());
  }
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController _controller = PageController();
  int? _displayedPage;
  int _currentPage = 0;

  @override
  void initState() {
    _controller.addListener(() {
      final controllerPage = _controller.page?.floor();
      setState(() {
        _currentPage = controllerPage as int;
      });
      if (controllerPage != null && controllerPage != _displayedPage) {
        _displayedPage = controllerPage;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.tutorialPage,
      child: StoreConnector<AppState, TutorialPageViewModel>(
        builder: (context, viewModel) => _content(viewModel),
        converter: (store) => TutorialPageViewModel.create(store),
        distinct: true,
      ),
    );
  }

  Widget _content(TutorialPageViewModel viewModel) {
    return Scaffold(
      body: Stack(
        children: [
          PrimaryRoundedBottomBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: Margins.spacing_base),
                _SkipButton(active: !_isLastPage(viewModel), viewModel: viewModel),
                SizedBox(height: Margins.spacing_base),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    children: [
                      for (var page in viewModel.pages)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
                          child: _TutorialContentCard(
                            title: page.title,
                            description: page.description,
                            image: page.image,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: Margins.spacing_base),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
                  child: PrimaryActionButton(
                    label: _isLastPage(viewModel) ? Strings.finish : Strings.continueLabel,
                    onPressed: () => _onPressed(viewModel),
                  ),
                ),
                SizedBox(height: Margins.spacing_base),
                _DelayedButton(viewModel: viewModel),
                SizedBox(height: Margins.spacing_base),
                Center(
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: viewModel.pages.length,
                    effect: WormEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.disabled,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),
                ),
                SizedBox(height: Margins.spacing_base),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isLastPage(TutorialPageViewModel viewModel) => _currentPage == viewModel.pages.length - 1;

  void _onPressed(TutorialPageViewModel viewModel) {
    final currentPage = _controller.page;
    setState(() {
      if (currentPage != null) _currentPage = _controller.page?.floor() as int;
    });
    if (currentPage != null && currentPage < viewModel.pages.length - 1) {
      _controller.animateToPage(
        currentPage.floor() + 1,
        duration: AnimationDurations.medium,
        curve: Curves.linearToEaseOut,
      );
      PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.continueTutorial);
    } else {
      viewModel.onDone();
      PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.doneTutorial);
    }
  }
}

class _SkipButton extends StatelessWidget {
  final bool active;
  final TutorialPageViewModel viewModel;

  const _SkipButton({
    required this.active,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Spacer(),
            InkWell(
              onTap: active
                  ? () {
                      viewModel.onDone();
                      PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.skipTutorial);
                    }
                  : null,
              child: Text(
                Strings.skip,
                style: TextStyles.textPrimaryButton.copyWith(color: active ? Colors.white : Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorialContentCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const _TutorialContentCard({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(Dimens.radius_base),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Dimens.radius_base)),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Animation(image: image),
                  SizedBox(height: Margins.spacing_base),
                  Text(title, style: TextStyles.textMBold.copyWith(color: AppColors.primary)),
                  SizedBox(height: Margins.spacing_base),
                  Text(description, style: TextStyles.textBaseRegular),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Animation extends StatefulWidget {
  final String image;

  const _Animation({required this.image});

  @override
  State<_Animation> createState() => _AnimationState();
}

class _AnimationState extends State<_Animation> with SingleTickerProviderStateMixin {
  bool _animating = false;

  late final AnimationController _animationController = AnimationController(
    duration: AnimationDurations.medium,
    reverseDuration: AnimationDurations.medium,
    vsync: this,
  );
  late final Animation<double> _offsetAnimation = Tween<double>(
    begin: 0,
    end: 30,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceInOut,
  ));

  Future<void> _playAnimation() async {
    await _animationController.forward(from: 0);
    await _animationController.reverse();
    await _animationController.forward(from: 0);
    await _animationController.reverse();
    await _animationController.forward(from: 0);
    await _animationController.reverse();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_animating) {
      _animating = true;
      _playAnimation();
    }
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, Widget? child) {
        return Transform.scale(
          scale: 1 + _offsetAnimation.value / 150,
          child: SvgPicture.asset(widget.image),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class _DelayedButton extends StatelessWidget {
  final TutorialPageViewModel viewModel;

  const _DelayedButton({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            viewModel.onDelay();
            PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.delayedTutorial);
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Text(Strings.seeLater, style: TextStyles.internalLink),
            ],
          ),
        ),
      ),
    );
  }
}
