import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/constants/colours.dart';


class InfoItems extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const InfoItems({
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
          color: MyConstants.primaryColor.withOpacity(0.6),
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
            fontSize: 14,
            color: MyConstants.primaryColor.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
