import 'package:fiyoh/common_widgets/date_picker.dart';
import 'package:fiyoh/common_widgets/dropdown.dart';
import 'package:fiyoh/common_widgets/long_button.dart';
import 'package:fiyoh/layouts/form/form_layout.dart';
import 'package:fiyoh/utils/date_handler.dart';
import 'package:flutter/material.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  String paymentType = 'RENT';

  @override
  void initState() {
    super.initState();
    // Set the start and end dates to the current month by default
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    _startDateController.text =
        firstDayOfMonth.toLocal().toString().split(' ')[0];
    _endDateController.text = lastDayOfMonth.toLocal().toString().split(' ')[0];
  }

  void _updateEndDate(DateTime startDate) {
    DateTime endDate;
    endDate = getLastDayOfMonth(startDate);
    setState(() {
      _endDateController.text = endDate.toLocal().toString().split(' ')[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      title: 'Add Payment',
      description: 'Track your payments',
      form: Column(
        children: [
          DropdownInput(
            labelText: 'Payment Type',
            items: const ['DEPOSIT'],
            onChanged: (value) {
              setState(() {
                paymentType = value;
              });
            },
            starter: 'RENT',
          ),
          if (paymentType == 'RENT')
            Row(
              children: [
                DatePickerInput(
                  labelText: 'Start Date',
                  hintText: 'Select Start Date',
                  controller: _startDateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a start date';
                    }
                    return null;
                  },
                  initialDate: getFirstDayOfMonth(DateTime.now()),
                  onChanged: (DateTime newDate) {
                    // Update end date when start date changes
                    _updateEndDate(newDate);
                  },
                ),
                const SizedBox(width: 20),
                DatePickerInput(
                  labelText: 'End Date',
                  hintText: 'Select End Date',
                  controller: _endDateController,
                  validator: (value) {
                    DateTime startDate =
                        DateTime.parse(_startDateController.text);
                    DateTime endDate = DateTime.parse(value ?? '');
                    if (value == null || value.isEmpty) {
                      return 'Please select an end date';
                    } else if (endDate.isBefore(startDate)) {
                      return 'End date cannot be before start date';
                    }
                    return null;
                  },
                  initialDate: getLastDayOfMonth(DateTime.now()),
                ),
              ],
            ),
        ],
      ),
      buttonContainer: LongButton(
        text: 'Add Payment',
        onPressed: () {},
      ),
      formKey: _formKey,
    );
  }
}
