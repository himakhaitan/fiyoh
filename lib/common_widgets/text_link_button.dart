import "package:fiyoh/constants/colours.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class TextLinkButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color bgColor;
  final Widget? icon;
  final double? fontSize;

  const TextLinkButton(
      {super.key, required this.onPressed, required this.text, this.color = Colors.blue, this.bgColor = Colors.transparent, this.icon, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: icon,
      style: TextButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: Colors.transparent,
        overlayColor: MyConstants.accentColor,
      ),
      onPressed: onPressed,
      label: Text(
        text,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.right,
        
      ),
    );
  }
}
