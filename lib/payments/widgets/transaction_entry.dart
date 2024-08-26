import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/form_input.dart';
import 'package:flutter/material.dart';

class TransactionEntry extends StatelessWidget {
  final String labelText;

  final TextEditingController controller;
  const TransactionEntry({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: DescriptiveText(
            text: labelText,
            fontWeight: FontWeight.w500,
          )),
          const SizedBox(width: 40),
          Expanded(
            child: FormInput(
              labelText: 'Amount',
              obscureText: false,
              hintText: 'xxxx.xx',
              controller: controller,
              icon: Icons.currency_rupee_sharp,
              validator: (value) {
                return null;
              },
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
        ],
      ),
    );
  }
}
