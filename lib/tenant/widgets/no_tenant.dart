import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/long_button.dart';
import 'package:flutter/material.dart';

class NoTenant extends StatelessWidget {
  const NoTenant({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/no_tenant.png',
            width: 300,
            height: 300,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: const DescriptiveText(text: "You have no tenants in this property yet", fontWeight: FontWeight.w600,),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: LongButton(text: 'Add Tenant', onPressed: () {
              Navigator.pushNamed(context, '/tenant/add');
            }),
          ),
          // TextLinkButton(onPressed: () {
          //   Navigator.pushNamed(context, '/tenant/add');
          // }, text: 'Add Tenant', color: MyConstants.text400, bgColor: MyConstants.accent100,),
        ],
      ),
    );
  }
}
