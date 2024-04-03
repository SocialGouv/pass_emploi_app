import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/chat/chat_content.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/preview_file_invisible_handler.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class ChatScaffold extends StatelessWidget {
  final DisplayState displayState;
  final VoidCallback onRetry;
  final ChatContent content;
  final String title;

  const ChatScaffold({
    required this.displayState,
    required this.onRetry,
    required this.content,
    this.title = Strings.menuChat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: PrimaryAppBar(title: title),
      body: ConnectivityContainer(
        child: Column(
          children: [
            SepLine(0, 0),
            Expanded(
              child: DefaultAnimatedSwitcher(
                child: _Body(
                  displayState: displayState,
                  content: content,
                  onRetry: onRetry,
                ),
              ),
            ),
            PreviewFileInvisibleHandler(),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final DisplayState displayState;
  final ChatContent content;
  final VoidCallback onRetry;

  const _Body({
    required this.displayState,
    required this.content,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return switch (displayState) {
      DisplayState.CONTENT => content,
      DisplayState.LOADING => Center(child: CircularProgressIndicator()),
      _ => Center(child: Retry(Strings.chatError, () => onRetry())),
    };
  }
}
