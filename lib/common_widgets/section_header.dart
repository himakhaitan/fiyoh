import 'package:rentwise/common_widgets/header_text.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String text;

  const SectionHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: HeaderText(
        text: text,
        fontSize: 18,
        color: MyConstants.primaryColor,
      ),
    );
  }
}
