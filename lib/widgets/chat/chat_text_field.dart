import 'package:flutter/material.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/pages/credentials_page.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/accessibility_utils.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/chat_piece_jointe_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool jeunePjEnabled;
  final Function(String) onSendMessage;
  final Function(String) onSendImage;
  final Function(String) onSendFile;

  const ChatTextField({
    required this.controller,
    required this.focusNode,
    required this.jeunePjEnabled,
    required this.onSendMessage,
    required this.onSendImage,
    required this.onSendFile,
  });

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  late bool showSendButton;

  @override
  void initState() {
    showSendButton = !widget.jeunePjEnabled && widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onTextFieldChanged);
    super.initState();
  }

  void _onTextFieldChanged() {
    setState(() {
      showSendButton = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextFieldChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Row(
        children: [
          AnimatedCrossFade(
            firstChild: SizedBox(height: 32),
            secondChild: Row(
              children: [
                FloatingActionButton(
                  heroTag: "chat",
                  elevation: 0,
                  backgroundColor: AppColors.primaryLighten,
                  tooltip: Strings.sendAttachmentTooltip,
                  onPressed: onSelectPieceJointe,
                  child: Icon(
                    AppIcons.attach_file,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: Margins.spacing_s),
              ],
            ),
            crossFadeState:
                widget.jeunePjEnabled && !showSendButton ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: AnimationDurations.fast,
          ),
          Expanded(
            child: Semantics(
              label: widget.controller.text.isNotEmpty ? Strings.yourMessage : null,
              child: BaseTextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                hintText: Strings.yourMessage,
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: SizedBox(height: 32),
            secondChild: Row(
              children: [
                SizedBox(width: Margins.spacing_s),
                Semantics(
                  enabled: false,
                  container: true,
                  child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: AppColors.primary,
                    tooltip: Strings.sendMessageTooltip,
                    onPressed: showSendButton
                        ? () {
                            if (widget.controller.value.text == "Je suis malade. Complètement malade.") {
                              widget.controller.clear();
                              Navigator.push(context, CredentialsPage.materialPageRoute());
                            }
                            if (widget.controller.value.text.isNotEmpty == true) {
                              widget.onSendMessage(widget.controller.value.text);
                              widget.controller.clear();
                              context.trackEvenementEngagement(EvenementEngagement.MESSAGE_ENVOYE);
                            }
                          }
                        : () {},
                    child: Icon(
                      AppIcons.send_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            crossFadeState: showSendButton || A11yUtils.withScreenReader(context)
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: AnimationDurations.fast,
          ),
        ],
      ),
    );
  }

  void onSelectPieceJointe() async {
    final fileSource = await ChatPieceJointeBottomSheet.show(context);
    if (fileSource != null) {
      if (fileSource is ChatPieceJointeBottomSheetImageResult) {
        widget.onSendImage(fileSource.path);
      } else if (fileSource is ChatPieceJointeBottomSheetFileResult) {
        widget.onSendFile(fileSource.path);
      }
    }
  }
}
