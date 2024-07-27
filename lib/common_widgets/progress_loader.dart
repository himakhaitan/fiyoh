// Widget to render Circular Progress Bar

import 'package:flutter/material.dart';
import 'package:fiyoh/constants/colours.dart';

class ProgressLoader extends StatelessWidget {
  const ProgressLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(MyConstants.accentColor),
      ),
    );
  }
}
