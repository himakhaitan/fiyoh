import 'package:rentwise/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LongButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double borderRadius;
  final TextStyle textStyle;
  final Color buttonColor;
  final Color textColor;

  LongButton({
    required this.text,
    required this.onPressed,
    this.borderRadius = 5.0,
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    this.buttonColor = MyConstants.whiteColor,
    this.textColor = MyConstants.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Take up full width
      child: ElevatedButton.icon(
        onPressed: onPressed,
        // icon: const Icon(Icons.arrow_forward, color: MyConstants.primaryColor, size: 22,),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(buttonColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          overlayColor: WidgetStateProperty.all(MyConstants.whiteColor.withOpacity(0.2)),
        ),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: textStyle.fontSize,
              fontWeight: textStyle.fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}