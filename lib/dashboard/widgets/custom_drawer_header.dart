import 'package:fiyoh/common_widgets/header_text.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: MyConstants.primary100,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/logo_dark.png',
              height: 40,
            ),
          ),
          SizedBox(height: 5.0),
          Align(
            alignment: Alignment.centerLeft,
            child: DescriptiveText(
              text: "A PG Management App!",
              color: MyConstants.text400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
