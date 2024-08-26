import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiyoh/constants/colours.dart';

class DatePickerInput extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onChanged; // Added onChanged callback

  const DatePickerInput({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.validator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onChanged, // Accepting onChanged callback
  });

  @override
  _DatePickerInputState createState() => _DatePickerInputState();
}

class _DatePickerInputState extends State<DatePickerInput> {
  @override
  void initState() {
    super.initState();
    // Initialize the text controller with the formatted initial date
    if (widget.initialDate != null) {
      widget.controller.text =
          widget.initialDate!.toLocal().toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: widget.controller,
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: widget.initialDate ?? DateTime.now(),
            firstDate: widget.firstDate ?? DateTime(2000),
            lastDate: widget.lastDate ?? DateTime(2101),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: MyConstants.brand100, 
                  colorScheme: const ColorScheme.light(
                    primary: MyConstants.brand100,
                    onSurface: MyConstants.text100, 
                  ),
                  dialogBackgroundColor: MyConstants.bg400, // background color
                ),
                child: child!,
              );
            },
          );
    
          if (pickedDate != null) {
            setState(() {
              widget.controller.text =
                  pickedDate.toLocal().toString().split(' ')[0];
              if (widget.onChanged != null) {
                widget
                    .onChanged!(pickedDate); // Trigger the onChanged callback
              }
            });
          }
        },
        decoration: InputDecoration(
          icon: const Icon(
            Icons.calendar_month_outlined, // Calendar icon
            color: MyConstants.primary100,
          ),
          labelText: widget.labelText,
          hintText: widget.hintText,
          labelStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: MyConstants.text100,
          ),
          hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: MyConstants.accent200, width: 2.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: MyConstants.accent200, width: 1.5),
          ),
        ),
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: MyConstants.text100,
        ),
        validator: widget.validator,
      ),
    );
  }
}
