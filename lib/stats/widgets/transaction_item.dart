import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/constants/colours.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: MyConstants.successMetallic,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_outward_outlined,
              color: MyConstants.primaryColor,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DescriptiveText(
                text: 'Rent Payment',
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
                text: '5000',
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
                text: 'Room 101',
                fontSize: 14,
                color: Colors.grey[600]!,
              ),
              const SizedBox(height: 5),
              DescriptiveText(
                text: 'Green Homes Platina',
                fontSize: 14,
                color: Colors.grey[600]!,
              ),
              const SizedBox(height: 5),
              DescriptiveText(
                text: '12/01/24',
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
