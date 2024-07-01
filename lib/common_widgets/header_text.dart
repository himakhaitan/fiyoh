import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const HeaderText({super.key, required this.text, this.color = Colors.white, this.fontSize = 25});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: color,
        fontSize: fontSize,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
