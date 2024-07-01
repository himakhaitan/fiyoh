import 'package:flutter/material.dart';
import 'package:rentwise/constants/colours.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyConstants.primaryColor,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: MyConstants.whiteColor,
          size: 30,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}