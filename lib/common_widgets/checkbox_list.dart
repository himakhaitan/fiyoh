// Packages: Imports
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:flutter/material.dart';

/// A form field for selecting multiple options using checkboxes.
///
/// The [CheckboxListFormField] widget displays a list of options as checkboxes.
/// The user can select multiple options by checking the checkboxes.
///
/// Example usage:
/// ```dart
/// CheckboxListFormField(
///   options: ['Option 1', 'Option 2', 'Option 3'],
///   onChanged: (index, value) { // Handle the checkbox selection
///   },
///   label: 'Heading',
///   selectedOptions: [false, false, false],
/// );
/// ```
class CheckboxListFormField extends StatefulWidget {
  /// The list of options to display as checkboxes.
  final List<String> options;

  /// A callback function that is called when a checkbox is selected.
  final void Function(int, bool) onChanged;

  /// The heading for the checkbox list.
  final String label;

  /// The list of selected options.
  final List<bool> selectedOptions;

  /// Creates a [CheckboxListFormField] widget.
  /// 
  /// The [options], [onChanged], [label], and [selectedOptions] parameters are required.
  /// The [options], [onChanged], [label], and [selectedOptions] parameters must not be null.
  /// The [selectedOptions] parameter must have the same length as the [options] parameter.
  /// The [onChanged] callback function must take an integer and a boolean as parameters.
  /// The [options] and [selectedOptions] parameters must have the same length.
  /// The [options] parameter must have at least one element.
  /// The [selectedOptions] parameter must have at least one element.
  /// The [onChanged] parameter must be a function.
  const CheckboxListFormField({
    super.key,
    required this.options,
    required this.onChanged,
    required this.label,
    required this.selectedOptions,
  });

  @override
  State<CheckboxListFormField> createState() => _CheckboxListFormFieldState();
}

class _CheckboxListFormFieldState extends State<CheckboxListFormField> {
  /// The list of selected options.
  List<bool> _currentSelection = [];

  /// Initializes the state of the widget.
  @override
  void initState() {
    /// Sets the initial state of the selected options.
    super.initState();

    /// Copies the selected options from the widget to the state.
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
          const SizedBox(height: 8),
          Column(
            children: List.generate(
              widget.options.length,
              (index) {
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

                  /// Handles the checkbox selection.
                  onChanged: (value) {
                    setState(() {
                      _currentSelection[index] = value!;
                    });
                    widget.onChanged(index, value!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
