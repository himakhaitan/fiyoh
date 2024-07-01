import 'package:rentwise/common_widgets/form_input.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/constants/colours.dart';

class PropertyRules<T> extends StatefulWidget {
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
  State<PropertyRules<T>> createState() => _PropertyRulesState<T>();
}

class _PropertyRulesState<T> extends State<PropertyRules<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SectionHeader(text: widget.label),
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.rules.add('');
                  });
                },
                icon: const Icon(
                  Icons.add_circle_outline_outlined,
                  color: MyConstants.accentColor,
                  size: 26,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DescriptiveText(
            text: widget.description,
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.rules.length,
            itemBuilder: (context, index) {
              return RuleInput(
                key: ValueKey('RuleInput_$index'),
                index: (index + 1).toString(),
                rule: widget.rules[index],
                onRemove: () {
                  setState(() {
                    widget.rules.removeAt(index);
                  });
                },
                onUpdateRule: (String value) {
                  setState(() {
                    widget.rules[index] = value;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class RuleInput extends StatefulWidget {
  final String rule;
  final String index;
  final ValueChanged<String> onUpdateRule;
  final VoidCallback onRemove;

  const RuleInput({
    super.key,
    required this.rule,
    required this.onUpdateRule,
    required this.index,
    required this.onRemove,
  });

  @override
  _RuleInputState createState() => _RuleInputState();
}

class _RuleInputState extends State<RuleInput> {
  late TextEditingController _ruleController;

  @override
  void initState() {
    super.initState();
    _ruleController = TextEditingController(text: widget.rule);

    // Listen for changes in the start and end controllers
    _ruleController.addListener(_onRuleChanged);
  }

  @override
  void dispose() {
    _ruleController.dispose();
    super.dispose();
  }

  // Callback when the starting room number changes
  void _onRuleChanged() {
    widget.onUpdateRule(_ruleController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: widget.onRemove,
          icon: const Icon(
            Icons.remove_circle_outline_outlined,
            color: MyConstants.accentColor,
            size: 26,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FormInput(
            labelText: 'Rule ${widget.index}',
            hintText: "State the Rule",
            obscureText: false,
            controller: _ruleController,
            validator: (value) {
              return null;
            },
          ),
        ),
      ],
    );
  }
}
