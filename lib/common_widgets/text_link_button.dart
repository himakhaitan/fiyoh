import "package:rentwise/constants/colours.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class TextLinkButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;

  const TextLinkButton(
      {super.key, required this.onPressed, required this.text, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        overlayColor: MyConstants.accentColor,
      ),
      onPressed: onPressed,
      child: Text(
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
