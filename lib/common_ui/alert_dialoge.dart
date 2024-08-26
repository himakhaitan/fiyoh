import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/long_button.dart';
import 'package:fiyoh/common_widgets/text_link_button.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Widget adaptiveAction(
    {required BuildContext context,
    required VoidCallback onPressed,
    required String text,
    Color textColor = MyConstants.primary100}) {
  final ThemeData theme = Theme.of(context);
  switch (theme.platform) {
    case TargetPlatform.android:
      return TextLinkButton(onPressed: onPressed, text: text, color: textColor);
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      return LongButton(
        text: text,
        onPressed: onPressed,
        textColor: textColor,
      );
    case TargetPlatform.iOS:
      return CupertinoDialogAction(
        onPressed: onPressed,
        child: DescriptiveText(
          text: text,
          color: textColor,
        ),
      );
    case TargetPlatform.macOS:
      return CupertinoDialogAction(
        onPressed: onPressed,
        child: DescriptiveText(
          text: text,
          color: textColor,
        ),
      );
  }
}

void showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required void Function() okayAction,
  required String okayText,
}) {
  showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: DescriptiveText(
            text: title,
            color: MyConstants.primary100,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          content: DescriptiveText(
            text: content,
            fontSize: 14,
          ),
          actions: [
            adaptiveAction(
              context: context,
              onPressed: () => Navigator.pop(context, 'Cancel'),
              text: "Cancel",
            ),
            adaptiveAction(
              context: context,
              onPressed: okayAction,
              text: "Delete",
              textColor: MyConstants.danger,
            ),
          ],
        );
      },
      useSafeArea: true);
}
