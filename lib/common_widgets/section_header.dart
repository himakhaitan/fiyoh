import 'package:fiyoh/common_widgets/header_text.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String text;
  final AlignmentGeometry alignment;
  const SectionHeader({super.key, required this.text, this.alignment = Alignment.centerLeft});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: HeaderText(
        text: text,
        fontSize: 18,
        color: MyConstants.text100,
      ),
    );
  }
}
