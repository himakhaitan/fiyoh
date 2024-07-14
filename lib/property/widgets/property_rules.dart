import 'package:rentwise/common_widgets/form_input.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/constants/colours.dart';

class PropertyRules extends StatefulWidget {
  final String label;
  final String description;
  List<String> rules;

  PropertyRules({
    super.key,
    required this.label,
    required this.description,
    required this.rules,
  });

  @override
  State<PropertyRules> createState() => _PropertyRulesState();
}

class _PropertyRulesState extends State<PropertyRules> {
  TextEditingController _ruleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(text: widget.label),
          const SizedBox(height: 8),
          DescriptiveText(
            text: widget.description,
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FormInput(
                  labelText: 'Rule ${widget.rules.length + 1}',
                  hintText: "State the Rule",
                  obscureText: false,
                  controller: _ruleController,
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  if (_ruleController.text.isNotEmpty) {
                    setState(() {
                    widget.rules.add(_ruleController.text);
                    _ruleController.clear();
                  });
                  }
                  
                },
                icon: const Icon(
                  Icons.add_circle_outline_outlined,
                  color: MyConstants.accentColor,
                  size: 26,
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.rules.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.rules.removeAt(index);
                      });
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline_outlined,
                      color: MyConstants.accentColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DescriptiveText(
                      text: widget.rules[index],
                      color: MyConstants.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
