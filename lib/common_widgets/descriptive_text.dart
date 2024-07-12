// Packages: Imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise/constants/colours.dart';

/// A widget for displaying descriptive text.
/// 
/// The [DescriptiveText] widget displays text with a specified color, font size, and font weight.
/// 
/// Example usage:
/// ```dart
/// DescriptiveText(
///   text: 'This is a descriptive text',
///   color: Colors.black,
///   fontSize: 16,
///   fontWeight: FontWeight.w400,
/// );
/// ```
class DescriptiveText extends StatelessWidget {
  /// The text to display.
  final String text;
  /// The color of the text.
  final Color color;
  /// The font size of the text.
  final double fontSize;
  /// The font weight of the text.
  final FontWeight? fontWeight;

  /// Creates a [DescriptiveText] widget.
  /// 
  /// The [text] parameter is required.
  /// The [text] parameter must not be null.
  /// The [color] parameter is optional.
  /// The [fontSize] parameter is optional.
  /// The [fontWeight] parameter is optional.
  /// The [color] parameter defaults to [MyConstants.primaryColor].
  /// The [fontSize] parameter defaults to 16.
  /// The [fontWeight] parameter defaults to [FontWeight.w400].
  /// The [fontSize] parameter must be greater than 0.
  /// The [fontWeight] parameter must be a [FontWeight] value.
  /// The [color] parameter must be a [Color] value.
  /// The [text] parameter must be a [String] value.
  const DescriptiveText({
    super.key,
    required this.text,
    this.color = MyConstants.primaryColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: color,
        fontSize: fontSize,
        height: 1.2,
        fontWeight: fontWeight,
      ),
    );
  }
}
