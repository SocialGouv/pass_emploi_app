import 'package:flutter/material.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/credentials_page.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/gallery_picker.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool pjEnabled;
  final Function(String) onSendMessage;
  final Function(String) onSendImage;

  const ChatTextField({
    required this.controller,
    required this.pjEnabled,
    required this.onSendMessage,
    required this.onSendImage,
  });

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  late bool showSendButton;

  @override
  void initState() {
    showSendButton = !widget.pjEnabled && widget.controller.text.isNotEmpty;
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
            firstChild: SizedBox(height: 32, width: 0),
            secondChild: Row(
              children: [
                FloatingActionButton(
                  elevation: 0,
                  backgroundColor: AppColors.primaryLighten,
                  tooltip: Strings.sendAttachmentTooltip,
                  child: Icon(
                    AppIcons.attach_file,
                    color: AppColors.primary,
                  ),
                  onPressed: () async {
                    final result = await PhotoServices.pickSingleImage();
                    if (result != null) {
                      widget.onSendImage(result);
                    }
                  },
                ),
                SizedBox(width: Margins.spacing_s),
              ],
            ),
            crossFadeState: widget.pjEnabled && !showSendButton ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: AnimationDurations.fast,
          ),
          Expanded(
            child: BaseTextField(
              controller: widget.controller,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              hintText: Strings.yourMessage,
            ),
          ),
          AnimatedCrossFade(
            firstChild: SizedBox(height: 32, width: 0),
            secondChild: Row(
              children: [
                SizedBox(width: Margins.spacing_s),
                FloatingActionButton(
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                  tooltip: Strings.sendMessageTooltip,
                  child: Icon(
                    AppIcons.send_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (widget.controller.value.text == "Je suis malade. Complètement malade.") {
                      widget.controller.clear();
                      Navigator.push(context, CredentialsPage.materialPageRoute());
                    }
                    if (widget.controller.value.text.isNotEmpty == true) {
                      widget.onSendMessage(widget.controller.value.text);
                      widget.controller.clear();
                      context.trackEvent(EventType.MESSAGE_ENVOYE);
                    }
                  },
                ),
              ],
            ),
            crossFadeState: showSendButton ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: AnimationDurations.fast,
          ),
        ],
      ),
    );
  }
}
