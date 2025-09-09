import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/information_bandeau.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CreateDemarcheIaFtStep2Page extends StatefulWidget {
  const CreateDemarcheIaFtStep2Page(this.viewModel);
  final CreateDemarcheFormViewModel viewModel;

  @override
  State<CreateDemarcheIaFtStep2Page> createState() => _CreateDemarcheIaFtStep2PageState();
}

class _CreateDemarcheIaFtStep2PageState extends State<CreateDemarcheIaFtStep2Page> {
  final SpeechToText _speechToText = SpeechToText();
  late final TextEditingController _textEditingController;
  bool _isListening = false;
  String? _errorText;

  Future<void> _startListening() async {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.createDemarcheEventCategory,
      action: AnalyticsEventNames.createDemarcheIaDicterPressed,
    );
    final bool available = await _speechToText.initialize(
      onError: (error) {
        setState(() => _errorText = Strings.genericError);
      },
    );
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(onResult: (result) {
        setState(() {
          if (result.recognizedWords.length >= CreateDemarcheIaFtStep2ViewModel.maxLength) {
            _stopListening();
          } else {
            _textEditingController.text = result.recognizedWords;
          }
        });
      });
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() => _isListening = false);
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.viewModel.iaFtStep2ViewModel.description);
    _textEditingController.addListener(() {
      widget.viewModel.iaFtDescriptionChanged(_textEditingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.createDemarcheIaFtStep2,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: Margins.spacing_base),
            Text(Strings.iaFtStep2Title, style: TextStyles.textMBold),
            const SizedBox(height: Margins.spacing_base),
            InformationBandeau(
              text: Strings.iaFtStep2Warning,
              icon: AppIcons.info,
              backgroundColor: AppColors.primaryLighten,
              textColor: AppColors.primary,
              borderRadius: Dimens.radius_base,
              padding: EdgeInsets.symmetric(
                vertical: Margins.spacing_s,
                horizontal: Margins.spacing_base,
              ),
            ),
            const SizedBox(height: Margins.spacing_base),
            Text(Strings.iaFtStep2FieldTitle, style: TextStyles.textBaseBold),
            const SizedBox(height: Margins.spacing_s),
            Stack(
              children: [
                BaseTextField(
                  controller: _textEditingController,
                  hintText: Strings.iaFtStep2FieldHint,
                  minLines: 6,
                  maxLines: null,
                  maxLength: CreateDemarcheIaFtStep2ViewModel.maxLength,
                  errorText: _errorText,
                  onChanged: (value) => setState(() => _errorText = null),
                  suffixIcon: Opacity(
                    opacity: 0,
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.close),
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      _textEditingController.clear();
                      setState(() => _errorText = null);
                    },
                    icon: Icon(Icons.close),
                    color: AppColors.contentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Margins.spacing_base),
            PrimaryActionButton(
              label: _isListening ? Strings.iaFtStep2ButtonStop : Strings.iaFtStep2ButtonDicter,
              onPressed: () {
                if (_isListening) {
                  _stopListening();
                } else {
                  _startListening();
                }
              },
              suffix: _isListening
                  ? SizedBox(
                      height: 24,
                      child: SoundWaveformWidget(),
                    )
                  : null,
              backgroundColor: AppColors.primaryLighten,
              textColor: AppColors.primary,
              iconColor: AppColors.primary,
              icon: _isListening ? Icons.stop_circle_rounded : Icons.mic,
              rippleColor: AppColors.primary.withOpacity(0.3),
            ),
            const SizedBox(height: Margins.spacing_base),
            PrimaryActionButton(
              label: Strings.iaFtStep2Button,
              onPressed: _textEditingController.text.isNotEmpty
                  ? () => widget.viewModel.navigateToCreateDemarcheIaFtStep3()
                  : null,
            ),
            const SizedBox(height: Margins.spacing_base),
            SizedBox(height: Margins.spacing_huge),
            SizedBox(height: Margins.spacing_huge),
            SizedBox(height: Margins.spacing_huge),
          ],
        ),
      ),
    );
  }
}

class SoundWaveformWidget extends StatefulWidget {
  final int count;
  final double minHeight;
  final double maxHeight;
  final int durationInMilliseconds;

  const SoundWaveformWidget({
    super.key,
    this.count = 6,
    this.minHeight = 10,
    this.maxHeight = 20,
    this.durationInMilliseconds = 1000,
  });
  @override
  State<SoundWaveformWidget> createState() => _SoundWaveformWidgetState();
}

class _SoundWaveformWidgetState extends State<SoundWaveformWidget> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: widget.durationInMilliseconds,
        ))
      ..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.count;
    final minHeight = widget.minHeight;
    final maxHeight = widget.maxHeight;
    return AnimatedBuilder(
      animation: controller,
      builder: (c, child) {
        final double t = controller.value;
        final int current = (count * t).floor();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            count,
            (i) => AnimatedContainer(
              duration: Duration(milliseconds: widget.durationInMilliseconds ~/ count),
              margin: i == (count - 1) ? EdgeInsets.zero : const EdgeInsets.only(right: 5),
              height: i == current ? maxHeight : minHeight,
              width: 4,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
        );
      },
    );
  }
}
