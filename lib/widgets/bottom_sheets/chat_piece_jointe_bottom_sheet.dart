import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/file_picker_wrapper.dart';
import 'package:pass_emploi_app/utils/image_picker_wrapper.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
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
  bool showPermissionDenied = false;

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

  void _pickFileEnded() {
    setState(() {
      showLoading = false;
    });
  }

  void _onPermissionError() {
    setState(() {
      showPermissionDenied = true;
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
              if (showPermissionDenied) ...[
                SizedBox(height: Margins.spacing_m),
                _PermissionDeniedWarning(),
              ],
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
              _TakePictureButton(
                onPickImagePermissionError: _onPermissionError,
              ),
              _SelectPictureButton(
                onPickImagePermissionError: _onPermissionError,
              ),
              _SelectFileButton(
                isFileTooLarge: _isFileTooLarge,
                onPermissionError: _onPermissionError,
                pickFileSarted: _pickFileSarted,
                pickFileEnded: _pickFileEnded,
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
  final void Function() onPickImagePermissionError;

  const _SelectPictureButton({required this.onPickImagePermissionError});
  @override
  Widget build(BuildContext context) {
    return _PieceJointeListTile(
      icon: AppIcons.image_outlined,
      text: Strings.chatPieceJointeBottomSheetSelectImageButton,
      onPressed: () async {
        final result = await ImagePickerWrapper.pickSingleImage();
        if (context.mounted && result is ImagePickerSuccessResult) {
          Navigator.of(context).pop(ChatPieceJointeBottomSheetImageResult(result.path));
        } else if (result is ImagePickerPermissionErrorResult) {
          onPickImagePermissionError();
        }
      },
    );
  }
}

class _TakePictureButton extends StatelessWidget {
  final void Function() onPickImagePermissionError;

  const _TakePictureButton({required this.onPickImagePermissionError});
  @override
  Widget build(BuildContext context) {
    return _PieceJointeListTile(
      icon: AppIcons.camera_alt_outlined,
      text: Strings.chatPieceJointeBottomSheetTakeImageButton,
      onPressed: () async {
        final result = await ImagePickerWrapper.takeSinglePicture();
        if (context.mounted && result is ImagePickerSuccessResult) {
          Navigator.of(context).pop(ChatPieceJointeBottomSheetImageResult(result.path));
        } else if (result is ImagePickerPermissionErrorResult) {
          onPickImagePermissionError();
        }
      },
    );
  }
}

class _SelectFileButton extends StatelessWidget {
  final void Function(bool isFileTooLarge) isFileTooLarge;
  final void Function() onPermissionError;
  final void Function() pickFileSarted;
  final void Function() pickFileEnded;
  const _SelectFileButton({
    required this.isFileTooLarge,
    required this.onPermissionError,
    required this.pickFileSarted,
    required this.pickFileEnded,
  });

  @override
  Widget build(BuildContext context) {
    return _PieceJointeListTile(
      icon: AppIcons.description_outlined,
      text: Strings.chatPieceJointeBottomSheetSelectFileButton,
      onPressed: () async {
        pickFileSarted();
        final result = await FilePickerWrapper.pickFile();
        if (result is FilePickerSuccessResult && context.mounted) {
          _onFilePicked(context, result);
        } else if (result is FilePickerPermissionErrorResult) {
          onPermissionError();
        }
        pickFileEnded();
      },
    );
  }

  void _onFilePicked(BuildContext context, FilePickerSuccessResult result) {
    final isTooLarge = result.isTooLarge;
    isFileTooLarge(isTooLarge);
    if (context.mounted && !isTooLarge) {
      Navigator.of(context).pop(ChatPieceJointeBottomSheetFileResult(result.path));
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
        Text(
          Strings.chatPieceJointeBottomSheetFileTooLarge,
          style: TextStyles.textBaseRegular.copyWith(color: AppColors.warning),
        ),
      ],
    );
  }
}

class _PermissionDeniedWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox.square(dimension: 100, child: Illustration.orange(AppIcons.image_not_supported_outlined)),
        SizedBox(height: Margins.spacing_base),
        Text(
          Strings.chatPieceJointePermissionError,
          style: TextStyles.textBaseRegular.copyWith(color: AppColors.alert),
        ),
        SizedBox(height: Margins.spacing_base),
        SizedBox(
          width: double.infinity,
          child: SecondaryButton(
            label: Strings.chatPieceJointeOpenAppSettings,
            onPressed: () => AppSettings.openAppSettings(),
          ),
        )
      ],
    );
  }
}

class _PieceJointeListTile extends StatelessWidget {
  const _PieceJointeListTile({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(text, style: TextStyles.textBaseBold),
      onTap: onPressed,
    );
  }
}
