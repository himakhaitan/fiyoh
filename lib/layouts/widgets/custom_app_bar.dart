import 'package:flutter/material.dart';
import 'package:rentwise/constants/colours.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  bool showLeading = true;
  CustomAppBar({super.key, this.showLeading = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyConstants.primaryColor,
      leading: showLeading ? IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: MyConstants.whiteColor,
          size: 30,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ): null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}