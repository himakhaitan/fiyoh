import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiyoh/constants/colours.dart';

class GoogleButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  const GoogleButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    // Return a CircularButton of Google Sign In

    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(
          'assets/images/google_icon.png',
          height: 30.0,
        ),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: MyConstants.primary100,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(MyConstants.colorGray100),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          overlayColor:
              WidgetStateProperty.all(MyConstants.bg100.withOpacity(0.2)),
          shadowColor: WidgetStatePropertyAll(MyConstants.colorGray100.withOpacity(0.5)),
        ),
      ),
    );
  }
}
