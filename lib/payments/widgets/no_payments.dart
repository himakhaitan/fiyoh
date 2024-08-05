import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/constants/colours.dart';
// import 'package:fiyoh/common_widgets/long_button.dart';
import 'package:flutter/material.dart';

class NoPayment extends StatelessWidget {
  const NoPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          Image.asset(
            'assets/images/no_transaction.png',
            width: 120,
            height: 120,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: const DescriptiveText(text: "No Transactions Yet", fontWeight: FontWeight.w600, color: MyConstants.text200,),
          ),
          // const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 60),
          //   child: LongButton(text: 'Add Tenant', onPressed: () {
          //     Navigator.pushNamed(context, '/tenant/add');
          //   }),
          // ),
          // TextLinkButton(onPressed: () {
          //   Navigator.pushNamed(context, '/tenant/add');
          // }, text: 'Add Tenant', color: MyConstants.text400, bgColor: MyConstants.accent100,),
        ],
      ),
    );
  }
}
