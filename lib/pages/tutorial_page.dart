import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/tutorial_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
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
      final _controllerPage = _controller.page?.floor();
      setState(() {
        _currentPage = _controllerPage as int;
      });
      if (_controllerPage != null && _controllerPage != _displayedPage) {
        _displayedPage = _controllerPage;
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
                _SkipButton(active: !_isLastPage(viewModel), viewModel: viewModel),
                SizedBox(height: Margins.spacing_base),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    children: [
                      for (var page in viewModel.pages)
                        _TutorialContentCard(
                          title: page.title,
                          description: page.description,
                          image: page.image,
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Margins.spacing_m),
                  child: PrimaryActionButton(
                    label: _isLastPage(viewModel) ? Strings.finish : Strings.continueLabel,
                    onPressed: () {
                      final currentPage = _controller.page;
                      setState(() {
                        if (currentPage != null) _currentPage = _controller.page?.floor() as int;
                      });
                      if (currentPage != null && currentPage < viewModel.pages.length - 1) {
                        _controller.animateToPage(
                          currentPage.floor() + 1,
                          duration: Duration(milliseconds: 600),
                          curve: Curves.linearToEaseOut,
                        );
                        MatomoTracker.trackScreenWithName(
                          AnalyticsActionNames.continueTutorial,
                          AnalyticsScreenNames.tutorialPage,
                        );
                      } else {
                        viewModel.onDone();
                        MatomoTracker.trackScreenWithName(
                          AnalyticsActionNames.doneTutorial,
                          AnalyticsScreenNames.tutorialPage,
                        );
                      }
                    },
                  ),
                ),
                _DelayedButton(viewModel: viewModel),
                Padding(
                  padding: const EdgeInsets.all(Margins.spacing_m),
                  child: Center(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isLastPage(TutorialPageViewModel viewModel) => _currentPage == viewModel.pages.length - 1;
}

class _SkipButton extends StatelessWidget {
  final bool active;
  final TutorialPageViewModel viewModel;

  const _SkipButton({
    required this.active,
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          Spacer(),
          InkWell(
            onTap: active
                ? () {
                    viewModel.onDone();
                    MatomoTracker.trackScreenWithName(
                      AnalyticsActionNames.skipTutorial,
                      AnalyticsScreenNames.tutorialPage,
                    );
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Margins.spacing_s,
                horizontal: Margins.spacing_base,
              ),
              child: Text(
                Strings.skip,
                style: TextStyles.textPrimaryButton.copyWith(color: active ? Colors.white : Colors.transparent),
              ),
            ),
          ),
        ],
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_m),
      child: Wrap(
        children: [
          Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(Margins.spacing_m),
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
        ],
      ),
    );
  }
}

class _Animation extends StatefulWidget {
  final String image;

  const _Animation({required this.image, Key? key}) : super(key: key);

  @override
  State<_Animation> createState() => _AnimationState();
}

class _AnimationState extends State<_Animation> with SingleTickerProviderStateMixin {
  bool _animating = false;

  late final AnimationController _controllerA = AnimationController(
    duration: const Duration(milliseconds: 300),
    reverseDuration: Duration(milliseconds: 300),
    vsync: this,
  );
  late final Animation<double> _offsetAnimation = Tween<double>(
    begin: 0,
    end: 30,
  ).animate(CurvedAnimation(
    parent: _controllerA,
    curve: Curves.linear,
  ));

  Future<void> _playAnimation() async {
    await _controllerA.forward(from: 0);
    await _controllerA.reverse();
    await _controllerA.forward(from: 0);
    await _controllerA.reverse();
    await _controllerA.forward(from: 0);
    await _controllerA.reverse();
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
          scale: 1 + _offsetAnimation.value / 200,
          child: Image.asset(widget.image, fit: BoxFit.fitWidth),
        );
      },
    );
  }
}

class _DelayedButton extends StatelessWidget {
  final TutorialPageViewModel viewModel;

  const _DelayedButton({required this.viewModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              viewModel.onDelay();
              MatomoTracker.trackScreenWithName(
                AnalyticsActionNames.delayedTutorial,
                AnalyticsScreenNames.tutorialPage,
              );
            },
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(Strings.seeLater, style: TextStyles.internalLink),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
