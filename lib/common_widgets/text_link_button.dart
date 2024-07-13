import "package:rentwise/constants/colours.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class TextLinkButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color bgColor;
  final Widget? icon;

  const TextLinkButton(
      {super.key, required this.onPressed, required this.text, this.color = Colors.blue, this.bgColor = Colors.transparent, this.icon});

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
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.right,
        
      ),
    );
  }
}
