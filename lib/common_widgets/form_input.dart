import 'package:fiyoh/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final IconData? icon;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  
  const FormInput({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.maxLines,
    this.icon,
    this.keyboardType = TextInputType.text,
    required this.validator
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        // Keyboard type should be text
        keyboardType: keyboardType,
        maxLines: obscureText ? 1 : maxLines,
        controller: controller,
        decoration: InputDecoration(
          icon: icon != null
              ? Icon(
                  icon,
                  color: MyConstants.primary100,
                )
              : null,
          labelText: labelText,
          hintText: hintText,
          labelStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: MyConstants.text100,
          ),
          hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyConstants.accent200, width: 2.0), // Change border color focused
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: MyConstants.accent200, width: 1.5), 
          ),
        ),
        obscureText: obscureText,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: MyConstants.text100,
        ),
        validator: validator,
      ),
    );
  }
}
