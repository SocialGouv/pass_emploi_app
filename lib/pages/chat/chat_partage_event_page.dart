import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/chat/chat_partage_event_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/media_sizes.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/confetti_wrapper.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class ChatPartageEventPage extends StatelessWidget {
  const ChatPartageEventPage({super.key});

  static Route<bool?> route() {
    return MaterialPageRoute<bool?>(
      fullscreenDialog: true,
      builder: (_) => const ChatPartageEventPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWrapper(builder: (context, confettiController) {
      return StoreConnector<AppState, ChatPartageEventViewModel>(
        converter: (store) => ChatPartageEventViewModel.create(store),
        builder: (context, vm) => _Builder(vm),
        onWillChange: (oldVm, newVm) => _onWillChange(oldVm, newVm, confettiController),
        distinct: true,
      );
    });
  }

  void _onWillChange(
    ChatPartageEventViewModel? oldVm,
    ChatPartageEventViewModel newVm,
    ConfettiController confettiController,
  ) {
    if (newVm.displayState == DisplayState.CONTENT && oldVm?.displayState != DisplayState.CONTENT) {
      confettiController.play();
    }
  }
}

class _Builder extends StatelessWidget {
  const _Builder(this.vm);
  final ChatPartageEventViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.demandeInscriptionConfirmationTitle),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: PrimaryActionButton(
            label: Strings.consulterAutresEvennements,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: switch (vm.displayState) {
        DisplayState.CONTENT => _Content(),
        DisplayState.FAILURE => _Failure(),
        _ => _Loading(),
      },
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(Margins.spacing_base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: height < MediaSizes.height_xs ? 60 : 180,
                child: Illustration.blue(
                  AppIcons.send_rounded,
                ),
              ),
              SizedBox(height: height < MediaSizes.height_xs ? Margins.spacing_base : Margins.spacing_l),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    Strings.demandeInscriptionDescription,
                    style: TextStyles.textMBold,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Margins.spacing_l),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _Failure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Retry(
      Strings.demandeInscriptionError,
      () => Navigator.of(context).pop(),
      buttonLabel: Strings.demandeInscriptionErrorButton,
    );
  }
}
