import 'package:flutter/material.dart';
import 'package:rentwise/constants/colours.dart';

class GoogleButton extends StatelessWidget {
  final void Function() onPressed;
  const GoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Return a CircularButton of Google Sign In

    return Material(
       color: Colors.transparent, // Ensure the background is transparent
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: MyConstants.greyColor.withOpacity(0.7),
              width: 1,
            ),
          ),
          child: Image.asset('assets/images/google_icon.png'),
        ),
      ),
    );
  }
}
