import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiyoh/constants/colours.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: MyConstants.redColor,
          fontSize: 14,
          height: 1.2,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
