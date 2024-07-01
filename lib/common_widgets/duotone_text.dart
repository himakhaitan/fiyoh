import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DuoToneText extends StatelessWidget {
  final String firstPart;
  final String highlightedPart;
  final String lastPart;
  final Color primaryColor;
  final Color secondaryColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;

  DuoToneText({
    required this.firstPart,
    required this.highlightedPart,
    required this.lastPart,
    required this.primaryColor,
    required this.secondaryColor,
    this.fontSize = 30,
    this.fontWeight = FontWeight.w700,
    this.height = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: firstPart,
            style: GoogleFonts.poppins(
              color: primaryColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              height: height,
            ),
          ),
          TextSpan(
            text: highlightedPart,
            style: GoogleFonts.poppins(
              color: secondaryColor, 
              fontSize: fontSize,
              fontWeight: fontWeight,
              height: height,
            ),
          ),
          TextSpan(
            text: lastPart,
            style: GoogleFonts.poppins(
              color: primaryColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              height: height,
            ),
          ),
        ],
      ),
    );
  }
}
