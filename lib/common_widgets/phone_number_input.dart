import 'package:rentwise/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise/common_widgets/form_input.dart';

class PhoneNumberInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final IconData? icon;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const PhoneNumberInput({
    super.key,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.icon,
    required this.controller,
    required this.validator
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), 
            child: Text(
              '+91',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: MyConstants.primaryColor,
              ),
            ),
            decoration: BoxDecoration(
              color: MyConstants.primaryColor.withOpacity(0.1), // Background color
              borderRadius: BorderRadius.circular(5), // Rounded corners
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: FormInput(
              labelText: labelText,
              hintText: hintText,
              obscureText: obscureText,
              controller: controller,
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
