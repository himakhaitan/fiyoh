import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise/constants/colours.dart';

class DropdownInput extends StatefulWidget {
  final String labelText;
  final List<String> items;
  final String starter;

  final void Function(String) onChanged;

  const DropdownInput({
    super.key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    required this.starter,
  });

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  String? _selectedItem;
  List<String> _items = [];

  void _updateItems() {
    setState(() {
      _selectedItem = widget.starter;
      _items = widget.items.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _updateItems();
  }

  @override
  void didUpdateWidget(DropdownInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _updateItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
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
