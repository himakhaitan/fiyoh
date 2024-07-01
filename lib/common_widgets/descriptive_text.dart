import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptiveText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight? fontWeight;

  const DescriptiveText({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: color,
        fontSize: fontSize,
        height: 1.2,
        fontWeight: fontWeight,
      ),
    );
  }
}
