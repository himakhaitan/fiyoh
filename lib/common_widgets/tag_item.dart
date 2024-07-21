import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/constants/colours.dart';

class TagItem extends StatelessWidget {
  final String text;
  final Color color;

  const TagItem({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: DescriptiveText(
        text: text,
        fontSize: 14,
        color: MyConstants.primaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
