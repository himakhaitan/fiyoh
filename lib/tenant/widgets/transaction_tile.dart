import 'package:fiyoh/models/transaction.dart';
import 'package:fiyoh/utils/date_handler.dart';
import 'package:flutter/material.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/info_item.dart';
import 'package:fiyoh/constants/colours.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyConstants.accent300,
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
                text: formatDate(transaction.transactionTimestamp),
                icon: Icons.calendar_today_outlined,
              ),
              const SizedBox(height: 5),
              InfoItem(
                text: transaction.transactionType,
                icon: Icons.monetization_on_outlined,
                color: MyConstants.orangeMetallic,
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.currency_rupee_outlined,
              ),
              DescriptiveText(text: transaction.amount.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
