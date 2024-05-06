import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/file_picker_wrapper.dart';
import 'package:pass_emploi_app/utils/image_picker_wrapper.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';

sealed class ChatPieceJointeBottomSheetResult {
  final String path;

  ChatPieceJointeBottomSheetResult({required this.path});
}

class ChatPieceJointeBottomSheetImageResult extends ChatPieceJointeBottomSheetResult {
  ChatPieceJointeBottomSheetImageResult(String path) : super(path: path);
}

class ChatPieceJointeBottomSheetFileResult extends ChatPieceJointeBottomSheetResult {
  ChatPieceJointeBottomSheetFileResult(String path) : super(path: path);
}

class ChatPieceJointeBottomSheet extends StatelessWidget {
  const ChatPieceJointeBottomSheet({super.key});

  static Future<ChatPieceJointeBottomSheetResult?> show(BuildContext context) async {
    return await showModalBottomSheet<ChatPieceJointeBottomSheetResult>(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Margins.spacing_m),
              _PieceJointeWarning(),
              SizedBox(height: Margins.spacing_base),
              _SelectFileButton(),
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
  @override
  Widget build(BuildContext context) {
    return Text(Strings.chatPieceJointeBottomSheetSubtitle, style: TextStyles.textSRegular());
  }
}

class _SelectPictureButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(AppIcons.image_outlined),
      contentPadding: EdgeInsets.zero,
      title: Text(Strings.chatPieceJointeBottomSheetImageButton, style: TextStyles.textBaseBold),
      onTap: () async {
        final result = await ImagePickerWrapper.pickSingleImage();
        if (result != null) {
          Future.delayed(Duration.zero, () => Navigator.of(context).pop(ChatPieceJointeBottomSheetImageResult(result)));
        }
      },
    );
  }
}

class _SelectFileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(AppIcons.description_outlined),
      contentPadding: EdgeInsets.zero,
      title: Text(Strings.chatPieceJointeBottomSheetFileButton, style: TextStyles.textBaseBold),
      onTap: () async {
        final result = await FilePickerWrapper.pickFile();
        if (result != null) {
          Future.delayed(Duration.zero, () => Navigator.of(context).pop(ChatPieceJointeBottomSheetFileResult(result)));
        }
      },
    );
  }
}
