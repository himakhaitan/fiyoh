import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/info_item.dart';
import 'package:rentwise/constants/colours.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyConstants.lightGreyColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const Icon(
          //   Icons.monetization_on_outlined,
          //   color: MyConstants.primaryColor,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoItem(
                text: "01/01/2024",
                icon: Icons.calendar_today_outlined,
              ),
              SizedBox(height: 5),
              InfoItem(
                text: "Rent",
                icon: Icons.monetization_on_outlined,
                color: MyConstants.orangeMetallic,
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.currency_rupee_outlined,
              ),
              DescriptiveText(text: "20,000"),
            ],
          ),
        ],
      ),
    );
  }
}
