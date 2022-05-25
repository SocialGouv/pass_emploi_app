import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/question_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class CampagneQuestionPage extends StatefulWidget {
  CampagneQuestionPage._() : super();

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CampagneQuestionPage._());
  }

  @override
  State<CampagneQuestionPage> createState() => _CampagneQuestionPageState();
}

class _CampagneQuestionPageState extends State<CampagneQuestionPage> {
  var _isAswered = false;
  String? _currentValue;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, QuestionPageViewModel>(
      converter: (store) => QuestionPageViewModel.create(store, 0),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      distinct: true,
    );
  }

  Widget _scaffold(BuildContext context, QuestionPageViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: viewModel.titre, context: context),
      body: _content(viewModel),
    );
  }

  Widget _content(QuestionPageViewModel viewModel) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Strings.mandatory, style: TextStyles.textSmRegular(color: AppColors.contentColor)),
            SizedBox(height: Margins.spacing_m),
            Text(viewModel.question, style: TextStyles.textBaseRegular),
            SizedBox(height: Margins.spacing_m),
            _answerOptions(viewModel.options),
            SizedBox(height: Margins.spacing_xl),
            Text(Strings.pourquoiTitle, style: TextStyles.textBaseBold),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.grey700, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: TextField(
                showCursor: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Margins.spacing_m),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: PrimaryActionButton(
                  onPressed: _isButtonEnabled() ? () => {} : null,
                  label: viewModel.bottomButton == QuestionBottomButton.next
                      ? Strings.nextButtonTitle
                      : Strings.validateButtonTitle,
                  iconSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isButtonEnabled() => _isAswered;

  Widget _answerOptions(List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options
          .map((answer) => RadioListTile<String>(
              controlAffinity: ListTileControlAffinity.trailing,
              selected: answer == _currentValue,
              title: Text(answer),
              value: answer,
              groupValue: _currentValue,
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                  _isAswered = true;
                });
              }))
          .toList(),
    );
  }
}
