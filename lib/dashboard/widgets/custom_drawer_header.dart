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
    return const DrawerHeader(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: MyConstants.primaryColor,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: HeaderText(
              text: "Roomwise",
              color: MyConstants.whiteColor,
            ),
          ),
          SizedBox(height: 5.0),
          Align(
            alignment: Alignment.centerLeft,
            child: DescriptiveText(text: "A PG Management App!"),
          ),
        ],
      ),
    );
  }
}
