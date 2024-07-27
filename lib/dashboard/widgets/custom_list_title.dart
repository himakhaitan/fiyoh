import 'package:fiyoh/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomListTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CustomListTitle({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
      ),
      child: ListTile(
        tileColor: Colors.white,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: MyConstants.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        leading: Icon(
          icon,
          color: MyConstants.accentColor,
        ),
      ),
    );
  }
}
