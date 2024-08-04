import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/long_button.dart';
import 'package:fiyoh/common_widgets/text_link_button.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:flutter/material.dart';

class NoProperty extends StatelessWidget {
  const NoProperty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/no_property.png',
            width: 300,
            height: 300,
          ),
          const DescriptiveText(text: "You have no properties yet", fontWeight: FontWeight.w600,),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: LongButton(text: 'Add Property', onPressed: () {
              Navigator.pushNamed(context, '/property/add');
            }),
          ),
          // TextLinkButton(onPressed: () {
          //   Navigator.pushNamed(context, '/property/add');
          // }, text: 'Add Property', color: MyConstants.text400, bgColor: MyConstants.accent100,),
        ],
      ),
    );
  }
}
