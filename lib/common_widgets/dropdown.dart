// Packages: Imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiyoh/constants/colours.dart';

/// A widget for displaying descriptive text.
/// 
/// The [DescriptiveText] widget displays text with a specified color, font size, and font weight.
/// 
/// Example usage:
/// ```dart
/// DropdownInput(
///   labelText: 'Select an option',
///   items: ['Option 1', 'Option 2', 'Option 3'],
///   starter: 'Select an option',
///   onChanged: (value) { // Handle the selected option
///   },
/// );
/// ```
class DropdownInput extends StatefulWidget {
  /// The label text for the dropdown input field.
  final String labelText;
  /// The list of items to display in the dropdown.
  final List<String> items;
  /// The initial value for the dropdown input field.
  final String starter;
  /// A callback function that is called when an item is selected.
  final void Function(String) onChanged;

  final String? initialValue;

  /// Creates a [DropdownInput] widget.
  /// 
  /// The [labelText], [items], [starter], and [onChanged] parameters are required.
  /// The [labelText], [items], [starter], and [onChanged] parameters must not be null.
  /// The [onChanged] callback function must take a string as a parameter.
  /// The [labelText] parameter must be a [String] value.
  /// The [items] parameter must be a list of [String] values.
  /// The [starter] parameter must be a [String] value.
  /// The [onChanged] parameter must be a function.
  const DropdownInput({
    super.key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    required this.starter,
    this.initialValue,
  });

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

/// The state of the [DropdownInput] widget.
/// 
/// The state of the [DropdownInput] widget is mutable.
/// The state of the [DropdownInput] widget can change based on user interaction.
class _DropdownInputState extends State<DropdownInput> {
  /// The selected item in the dropdown.
  String? _selectedItem;
  /// The list of items to display in the dropdown.
  List<String> _items = [];

  /// Updates the list of items in the dropdown.
  void _updateItems() {
    /// Sets the selected item to the initial value.
    setState(() {
      _selectedItem = widget.initialValue ?? widget.starter;
      _items = widget.items.toList();
    });
  }

  /// Initializes the state of the widget.
  @override
  void initState() {
    /// Sets the initial state of the selected item and items.
    super.initState();
    /// Updates the list of items in the dropdown.
    _updateItems();
  }

  /// Updates the widget based on the new widget.
  @override
  void didUpdateWidget(DropdownInput oldWidget) {
    /// Updates the list of items in the dropdown.
    super.didUpdateWidget(oldWidget);
    /// Checks if the items in the dropdown have changed.
    if (widget.items != oldWidget.items ||  widget.initialValue != oldWidget.initialValue) {
      _updateItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        /// The selected item in the dropdown.
        onChanged: (String? value) {
          setState(() {
            _selectedItem = value;
          });
          widget.onChanged(value ?? "");
        },
        value: _selectedItem,
        borderRadius: BorderRadius.circular(10),
        dropdownColor: MyConstants.whiteColor,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: MyConstants.primaryColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: MyConstants.accentColor, width: 2.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
        ),
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: MyConstants.primaryColor,
        ),
        items: [
          DropdownMenuItem<String>(
            value: widget.starter,
            child: Text(widget.starter),
          ),
          ..._items.map((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: MyConstants.primaryColor,
                  ),
                ));
          }),
        ],
        validator: (value) {
          if (value == null || value.isEmpty || value == widget.starter) {
            return 'Please select a value';
          }
          return null;
        },
      ),
    );
  }
}
