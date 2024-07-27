import 'package:flutter/material.dart';
import 'package:fiyoh/constants/colours.dart';

Future<dynamic> showBottomModal(BuildContext context, List<Widget> content) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: MyConstants.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          width: double.infinity,
          child: Column(
            children: content,
          ),
        );
      });
}
