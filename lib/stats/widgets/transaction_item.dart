import 'package:fiyoh/payments/models/payment.dart';
import 'package:fiyoh/utils/date_handler.dart';
import 'package:fiyoh/utils/format_double.dart';
import 'package:flutter/material.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/constants/colours.dart';

class TransactionItem extends StatelessWidget {
  final Payment payment;
  const TransactionItem({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyConstants.colorGray500,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color:  MyConstants.brand400,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
               Icons.south_east_outlined,
              color: MyConstants.primaryColor,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DescriptiveText(
                text: (payment.transactionType == 'RENT')? 'Rent - ${getMonthName(payment.startDate!.month)}' : 'Deposit',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.currency_rupee_outlined,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                  DescriptiveText(
                    // INR
                    text: formatDouble(payment.amount),
                    fontSize: 14,
                    color: Colors.grey[600]!,
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DescriptiveText(
                text: payment.propertyName,
                fontSize: 14,
                color: Colors.grey[600]!,
              ),
              const SizedBox(height: 5),
              DescriptiveText(
                text: formatDate(payment.transactionTimestamp),
                fontSize: 14,
                color: Colors.grey[600]!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
