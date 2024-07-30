import 'package:flutter/material.dart';
import 'package:fiyoh/constants/colours.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  bool showLeading = true;
  CustomAppBar({super.key, this.showLeading = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: MyConstants.primary100,
        leading: showLeading
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: MyConstants.bg400,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        centerTitle: true,
        actions: [
          Image.asset(
            'assets/images/logo_dark.png',
            fit: BoxFit.cover,
            height: 40,
          ),
          SizedBox(width: 20,)
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
