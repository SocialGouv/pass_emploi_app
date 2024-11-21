import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/in_app_feedback/in_app_feedback_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

// TODO Set proper analytics events
enum _Feedback {
  moodBad(
    icon: AppIcons.mood_bad,
    semantics: Strings.moodBad,
    analyticsEvent: Strings.moodBad,
  ),
  sentimentDissatisfied(
    icon: AppIcons.sentiment_dissatisfied,
    semantics: Strings.sentimentDissatisfied,
    analyticsEvent: Strings.sentimentDissatisfied,
  ),
  sentimentNeutral(
    icon: AppIcons.sentiment_neutral,
    semantics: Strings.sentimentNeutral,
    analyticsEvent: Strings.sentimentNeutral,
  ),
  sentimentSatisfied(
    icon: AppIcons.sentiment_satisfied,
    semantics: Strings.sentimentSatisfied,
    analyticsEvent: Strings.sentimentSatisfied,
  ),
  mood(
    icon: AppIcons.mood,
    semantics: Strings.mood,
    analyticsEvent: Strings.mood,
  );

  final IconData icon;
  final String semantics;
  final String analyticsEvent;

  const _Feedback({required this.icon, required this.semantics, required this.analyticsEvent});
}

enum _WidgetState {
  feedback,
  thanks,
  closed,
}

class InAppFeedback extends StatefulWidget {
  final String feature;
  final String label;
  final EdgeInsetsGeometry padding;

  const InAppFeedback({required this.feature, required this.label, this.padding = EdgeInsets.zero});

  @override
  State<InAppFeedback> createState() => _InAppFeedbackState();
}

class _InAppFeedbackState extends State<InAppFeedback> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationDurations.extraLong,
      vsync: this,
    )..forward(from: 0.3);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      onInit: (store) => store.dispatch(InAppFeedbackRequestAction(widget.feature)),
      rebuildOnChange: false, // to avoid animation are stopped when state changes
      converter: (store) => store.state.inAppFeedbackState.feedbackActivationForFeatures[widget.feature] ?? false,
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, bool display) {
    return switch (display) {
      true => AnimatedBuilder(
          animation: _animation,
          child: _InAppFeedbackWidget(feature: widget.feature, label: widget.label, padding: widget.padding),
          builder: (context, child) => Transform.scale(scale: _animation.value, child: child)),
      false => SizedBox.shrink(),
    };
  }
}

class _InAppFeedbackWidget extends StatefulWidget {
  final String feature;
  final String label;
  final EdgeInsetsGeometry padding;

  const _InAppFeedbackWidget({required this.feature, required this.label, required this.padding});

  @override
  State<_InAppFeedbackWidget> createState() => _InAppFeedbackWidgetState();
}

class _InAppFeedbackWidgetState extends State<_InAppFeedbackWidget> {
  _WidgetState state = _WidgetState.feedback;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AnimationDurations.fast,
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeOutBack,
      transitionBuilder: (child, animation) => SizeTransition(sizeFactor: animation, child: child),
      child: switch (state) {
        _WidgetState.feedback => Padding(
            key: ValueKey<int>(0),
            padding: widget.padding,
            child: Stack(
              children: [
                _BorderedContainer(
                  child: Column(
                    children: [
                      _Description(icon: AppIcons.help, label: widget.label),
                      SizedBox(height: Margins.spacing_m),
                      _FeedbackOptionsGroup(
                        onOptionTap: (feedback) {
                          setState(() => state = _WidgetState.thanks);
                          // TODO: send analytics event
                          // TODO: dispatch action to close feedback
                        },
                      ),
                      SizedBox(height: 12),
                      _FeedbackCaption(),
                      SizedBox(height: Margins.spacing_base),
                    ],
                  ),
                ),
                _CloseButton(onPressed: () {
                  setState(() => state = _WidgetState.closed);
                  // TODO: dispatch action to close feedback
                })
              ],
            ),
          ),
        _WidgetState.thanks => Padding(
            key: ValueKey<int>(1),
            padding: widget.padding,
            child: _Thanks(onPressed: () => setState(() => state = _WidgetState.closed)),
          ),
        _WidgetState.closed => SizedBox.shrink(key: ValueKey<int>(2)),
      },
    );
  }
}

class _Description extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Description({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary),
        SizedBox(width: Margins.spacing_s),
        Flexible(child: Text(label, style: TextStyles.textSBold)),
        // Extra margin is added to avoid the close button to be too close to the text
        SizedBox(width: 30),
      ],
    );
  }
}

class _FeedbackOptionsGroup extends StatelessWidget {
  final Function(_Feedback) onOptionTap;

  const _FeedbackOptionsGroup({required this.onOptionTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _FeedbackOption(
          feedback: _Feedback.moodBad,
          onTap: () => onOptionTap(_Feedback.moodBad),
        ),
        _FeedbackOption(
          feedback: _Feedback.sentimentDissatisfied,
          onTap: () => onOptionTap(_Feedback.sentimentDissatisfied),
        ),
        _FeedbackOption(
          feedback: _Feedback.sentimentNeutral,
          onTap: () => onOptionTap(_Feedback.sentimentNeutral),
        ),
        _FeedbackOption(
          feedback: _Feedback.sentimentSatisfied,
          onTap: () => onOptionTap(_Feedback.sentimentSatisfied),
        ),
        _FeedbackOption(
          feedback: _Feedback.mood,
          onTap: () => onOptionTap(_Feedback.mood),
        ),
      ],
    );
  }
}

class _FeedbackOption extends StatelessWidget {
  final _Feedback feedback;
  final VoidCallback onTap;

  const _FeedbackOption({required this.feedback, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Semantics(
        label: feedback.semantics,
        button: true,
        child: Material(
          color: AppColors.primaryLighten,
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(Dimens.radius_base),
          child: InkWell(
            splashColor: AppColors.primary,
            onTap: onTap,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.radius_base),
                border: Border.all(color: AppColors.primary),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_s, vertical: Margins.spacing_base),
                child: Icon(
                  feedback.icon,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackCaption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const maxWidthForLargeTextScale = 100.0;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: maxWidthForLargeTextScale,
            child: Text(Strings.feedbackBad, style: TextStyles.textSMedium(color: AppColors.grey800)),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: maxWidthForLargeTextScale,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(Strings.feedbackNeutral, style: TextStyles.textSMedium(color: AppColors.grey800)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            width: maxWidthForLargeTextScale,
            child: Align(
              alignment: Alignment.topRight,
              child: Text(Strings.feedbackGood, style: TextStyles.textSMedium(color: AppColors.grey800)),
            ),
          ),
        ),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CloseButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_xs),
        child: IconButton(
          icon: Icon(AppIcons.close_rounded),
          tooltip: Strings.close,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _Thanks extends StatelessWidget {
  final VoidCallback onPressed;

  const _Thanks({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _BorderedContainer(
          child: _Description(icon: AppIcons.check_circle_outline_rounded, label: Strings.feedbackThanks),
        ),
        _CloseButton(onPressed: onPressed),
      ],
    );
  }
}

class _BorderedContainer extends StatelessWidget {
  final Widget child;

  const _BorderedContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.circular(Dimens.radius_base),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: child,
      ),
    );
  }
}
