import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/image_picker_wrapper.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';

class ChatPieceJointeBottomSheet extends StatelessWidget {
  const ChatPieceJointeBottomSheet({super.key});

  static Future<String?> show(BuildContext context) async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ChatPieceJointeBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      title: Strings.chatPieceJointeBottomSheetTitle,
      heightFactor: BottomSheetWrapper.smallHeightFactor(context),
      body: SizedBox(
        width: double.infinity,
        child: OverflowBox(
          maxHeight: double.infinity,
          maxWidth: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: Margins.spacing_m),
              _PieceJointeWarning(),
              SizedBox(height: Margins.spacing_base),
              _SelectPictureButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PieceJointeWarning extends StatelessWidget {
  const _PieceJointeWarning();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Text(Strings.chatPieceJointeBottomSheetSubtitle, style: TextStyles.textSRegular()),
    );
  }
}

class _SelectPictureButton extends StatelessWidget {
  const _SelectPictureButton();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(AppIcons.image_outlined),
      title: Text(Strings.chatPieceJointeBottomSheetImageButton, style: TextStyles.textBaseBold),
      onTap: () async {
        final result = await ImagePickerWrapper.pickSingleImage();
        if (result != null) {
          Future.delayed(Duration.zero, () => Navigator.of(context).pop(result));
        }
      },
    );
  }
}
