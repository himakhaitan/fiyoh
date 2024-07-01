import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:flutter/material.dart';

class CheckboxListFormField extends StatefulWidget {
  final List<String> options;
  final void Function(int, bool) onChanged;
  final String label;
  final List<bool> selectedOptions;

  const CheckboxListFormField({
    super.key,
    required this.options,
    required this.onChanged,
    required this.label,
    required this.selectedOptions,
  });

  @override
  _CheckboxListFormFieldState createState() => _CheckboxListFormFieldState();
}

class _CheckboxListFormFieldState extends State<CheckboxListFormField> {
  List<bool> _currentSelection = [];

  @override
  void initState() {
    super.initState();
    _currentSelection = List<bool>.from(widget.selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(text: widget.label),
          // DescriptiveText(
          //   text: widget.label,
          //   color: MyConstants.primaryColor,
          //   fontSize: 18,
          //   fontWeight: FontWeight.w500,
          // ),
          const SizedBox(height: 8),
          Column(
            children: List.generate(widget.options.length, (index) {
              return CheckboxListTile(
                checkColor: MyConstants.whiteColor,
                activeColor: MyConstants.primaryColor,
                title: DescriptiveText(
                  text: widget.options[index],
                  color: MyConstants.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                value: _currentSelection[index],
                onChanged: (value) {
                  setState(() {
                    _currentSelection[index] = value!;
                  });
                  widget.onChanged(index, value!);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
