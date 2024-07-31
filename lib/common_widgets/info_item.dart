import 'package:flutter/material.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/constants/colours.dart';


class InfoItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const InfoItem({
    super.key,
    required this.text,
    required this.icon,
    this.color = Colors.transparent
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: MyConstants.primary200,
          size: 20,
        ),
        const SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: DescriptiveText(
            text: text,
            fontSize: 12,
            color: MyConstants.primary100,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
