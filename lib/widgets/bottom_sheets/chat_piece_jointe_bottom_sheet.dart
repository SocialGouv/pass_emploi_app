import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/file_picker_wrapper.dart';
import 'package:pass_emploi_app/utils/image_picker_wrapper.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

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

class ChatPieceJointeBottomSheet extends StatefulWidget {
  const ChatPieceJointeBottomSheet({super.key});

  static Future<ChatPieceJointeBottomSheetResult?> show(BuildContext context) async {
    return await showModalBottomSheet<ChatPieceJointeBottomSheetResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ChatPieceJointeBottomSheet(),
    );
  }

  @override
  State<ChatPieceJointeBottomSheet> createState() => _ChatPieceJointeBottomSheetState();
}

class _ChatPieceJointeBottomSheetState extends State<ChatPieceJointeBottomSheet> {
  bool showFileTooLargeMessage = false;
  bool showLoading = false;

  void _isFileTooLarge(bool isFileTooLarge) {
    setState(() {
      showLoading = false;
      showFileTooLargeMessage = isFileTooLarge;
    });
  }

  void _pickFileSarted() {
    setState(() {
      showLoading = true;
      showFileTooLargeMessage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      title: Strings.chatPieceJointeBottomSheetTitle,
      heightFactor: 0.7,
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (showFileTooLargeMessage) ...[
                SizedBox(height: Margins.spacing_m),
                _FileTooLargeWarning(),
              ],
              if (showLoading) ...[
                SizedBox(height: Margins.spacing_m),
                _Loading(),
              ],
              SizedBox(height: Margins.spacing_m),
              _PieceJointeWarning(),
              SizedBox(height: Margins.spacing_base),
              _TakePictureButton(),
              _SelectFileButton(
                isFileTooLarge: _isFileTooLarge,
                pickFileSarted: _pickFileSarted,
              ),
              _SelectPictureButton(),
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
    return SizedBox.square(
      dimension: 40,
      child: CircularProgressIndicator(),
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
      title: Text(Strings.chatPieceJointeBottomSheetSelectImageButton, style: TextStyles.textBaseBold),
      onTap: () async {
        final result = await ImagePickerWrapper.pickSingleImage();
        if (result != null) {
          // Navigator.pop is called in a future to avoir error with context:
          Future.delayed(Duration.zero, () => Navigator.of(context).pop(ChatPieceJointeBottomSheetImageResult(result)));
        }
      },
    );
  }
}

class _TakePictureButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(AppIcons.camera_alt_outlined),
      contentPadding: EdgeInsets.zero,
      title: Text(Strings.chatPieceJointeBottomSheetTakeImageButton, style: TextStyles.textBaseBold),
      onTap: () async {
        final result = await ImagePickerWrapper.takeSinglePicture();
        if (result != null) {
          // Navigator.pop is called in a future to avoir error with context:
          Future.delayed(Duration.zero, () => Navigator.of(context).pop(ChatPieceJointeBottomSheetImageResult(result)));
        }
      },
    );
  }
}

class _SelectFileButton extends StatelessWidget {
  final void Function(bool isFileTooLarge) isFileTooLarge;
  final void Function() pickFileSarted;
  const _SelectFileButton({required this.isFileTooLarge, required this.pickFileSarted});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(AppIcons.description_outlined),
      contentPadding: EdgeInsets.zero,
      title: Text(Strings.chatPieceJointeBottomSheetSelectFileButton, style: TextStyles.textBaseBold),
      onTap: () async {
        pickFileSarted();
        final result = await FilePickerWrapper.pickFile();
        if (context.mounted) {
          _onFilePicked(context, result);
        }
      },
    );
  }

  void _onFilePicked(BuildContext context, FilePickerOutput? result) {
    if (result != null) {
      final isTooLarge = result.isTooLarge;
      isFileTooLarge(isTooLarge);
      if (!isTooLarge) {
        Navigator.of(context).pop(ChatPieceJointeBottomSheetFileResult(result.path));
      }
    }
  }
}

class _FileTooLargeWarning extends StatelessWidget {
  const _FileTooLargeWarning();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox.square(dimension: 100, child: Illustration.red(AppIcons.error_rounded)),
        SizedBox(height: Margins.spacing_base),
        Text(Strings.chatPieceJointeBottomSheetFileTooLarge,
            style: TextStyles.textBaseRegular.copyWith(color: AppColors.warning)),
      ],
    );
  }
}
