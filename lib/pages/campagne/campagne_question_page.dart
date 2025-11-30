import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/presentation/question_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/radio_list_tile.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

const maxAnswerLength = 255;

class CampagneQuestionPage extends StatefulWidget {
  final int questionOffset;

  CampagneQuestionPage._(this.questionOffset) : super();

  static MaterialPageRoute<void> materialPageRoute(int questionOffset) {
    return MaterialPageRoute(builder: (context) => CampagneQuestionPage._(questionOffset));
  }

  @override
  State<CampagneQuestionPage> createState() => _CampagneQuestionPageState();
}

class _CampagneQuestionPageState extends State<CampagneQuestionPage> {
  int? _answerId;
  String? _pourquoi;
  final GlobalKey _textFieldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, QuestionPageViewModel>(
      converter: (store) => QuestionPageViewModel.create(store, widget.questionOffset),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      distinct: true,
    );
  }

  Widget _scaffold(BuildContext context, QuestionPageViewModel viewModel) {
    const backgroundColor = Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: viewModel.titre, backgroundColor: backgroundColor),
      body: _content(viewModel),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
        child: SizedBox(
          width: double.infinity,
          child: PrimaryActionButton(
            onPressed: _answerId != null ? () => onButtonPressed(viewModel) : null,
            label: viewModel.bottomButton == QuestionBottomButton.next
                ? Strings.nextButtonTitle
                : Strings.validateButtonTitle,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _content(QuestionPageViewModel viewModel) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Strings.mandatory, style: TextStyles.textSRegular(color: AppColors.contentColor)),
            SizedBox(height: Margins.spacing_base),
            Text(viewModel.question, style: TextStyles.textBaseBold),
            SizedBox(height: Margins.spacing_base),
            _answerOptions(viewModel.options),
            SizedBox(height: Margins.spacing_xl),
            Text(Strings.pourquoiTitle, style: TextStyles.textBaseRegular),
            SizedBox(height: Margins.spacing_base),
            BaseTextField(
              key: _textFieldKey,
              onTap: () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  Scrollable.ensureVisible(_textFieldKey.currentContext!);
                });
              },
              onChanged: (value) {
                Scrollable.ensureVisible(_textFieldKey.currentContext!);

                setState(() => _pourquoi = value);
              },
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              maxLength: maxAnswerLength,
              hintText: Strings.pourquoiHintText,
            ),
            SizedBox(height: Margins.spacing_x_huge * 2),
          ],
        ),
      ),
    );
  }

  void onButtonPressed(QuestionPageViewModel viewModel) {
    submitAnswer(viewModel);
    if (viewModel.bottomButton == QuestionBottomButton.next) {
      Navigator.push(context, CampagneQuestionPage.materialPageRoute(widget.questionOffset + 1));
    } else {
      Navigator.of(context).popAll();
      showSnackBarWithSuccess(context, Strings.evaluationSuccessfullySent);
    }
  }

  void submitAnswer(QuestionPageViewModel viewModel) {
    viewModel.onButtonClick(viewModel.idQuestion, _answerId!, _pourquoi);
  }

  Widget _answerOptions(List<Option> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options
          .map((option) => CustomRadioGroup<int>(
              title: option.libelle,
              value: option.id,
              groupValue: _answerId,
              onChanged: (value) {
                setState(() {
                  _answerId = value;
                });
              }))
          .toList(),
    );
  }
}
