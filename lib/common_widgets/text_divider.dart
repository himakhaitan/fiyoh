import 'package:flutter/material.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/constants/colours.dart';
class TextDivider extends StatelessWidget {
  const TextDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 10, left: 50),
            child: const Divider(
              color: MyConstants.greyColor,
              thickness: 1,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const DescriptiveText(text: "OR"),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 50),
            child: const Divider(
              color: MyConstants.greyColor,
              thickness: 1,
            ),
          ),
        ),
      ],
    );
  }
}