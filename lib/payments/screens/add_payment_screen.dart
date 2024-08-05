import 'package:fiyoh/common_widgets/date_picker.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/dropdown.dart';
import 'package:fiyoh/common_widgets/error_message.dart';
import 'package:fiyoh/common_widgets/long_button.dart';
import 'package:fiyoh/common_widgets/progress_loader.dart';
import 'package:fiyoh/common_widgets/section_header.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/layouts/form/form_layout.dart';
import 'package:fiyoh/payments/bloc/payment_bloc.dart';
import 'package:fiyoh/payments/widgets/transaction_entry.dart';
import 'package:fiyoh/tenant/bloc/tenant_bloc.dart';
import 'package:fiyoh/utils/date_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPaymentScreen extends StatefulWidget {
  final String bookingID;
  final String propertyID;
  const AddPaymentScreen(
      {super.key, required this.bookingID, required this.propertyID});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _rentController = TextEditingController(text: '0');
  final _foodController = TextEditingController(text: '0');
  final _electricityController = TextEditingController(text: '0');
  final _laundryController = TextEditingController(text: '0');
  final _miscController = TextEditingController(text: '0');
  final _nonRefundableController = TextEditingController(text: '0');
  final _refundableController = TextEditingController(text: '0');
  String paymentType = 'RENT';
  String breakdownNature = '';
  String paymentMethod = 'CASH';
  double totalAmount = 0.00;
  String _error = '';
  bool _loading = false;

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

    // Add listener
    _rentController.addListener(() {
      _calculateTotalAmount();
    });
    _foodController.addListener(() {
      _calculateTotalAmount();
    });
    _electricityController.addListener(() {
      _calculateTotalAmount();
    });
    _laundryController.addListener(() {
      _calculateTotalAmount();
    });
    _miscController.addListener(() {
      _calculateTotalAmount();
    });
    _nonRefundableController.addListener(() {
      _calculateTotalAmount();
    });
    _refundableController.addListener(() {
      _calculateTotalAmount();
    });
  }

  void _calculateTotalAmount() {
    double rent = double.tryParse(_rentController.text) ?? 0.00;
    double food = double.tryParse(_foodController.text) ?? 0.00;
    double electricity = double.tryParse(_electricityController.text) ?? 0.00;
    double laundry = double.tryParse(_laundryController.text) ?? 0.00;
    double misc = double.tryParse(_miscController.text) ?? 0.00;
    double nonRefundable =
        double.tryParse(_nonRefundableController.text) ?? 0.00;
    double refundable = double.tryParse(_refundableController.text) ?? 0.00;

    setState(() {
      if (paymentType == 'RENT') {
        totalAmount = rent + food + electricity + laundry + misc;
      } else if (paymentType == 'DEPOSIT') {
        totalAmount = nonRefundable + refundable;
      }
    });
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
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          setState(() {
            _loading = false;
          });
          context
              .read<TenantBloc>()
              .add(GetTenants(propertyId: widget.propertyID));
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is PaymentFailed) {
          setState(() {
            _loading = false;
            _error = state.error;
          });
        } else if (state is PaymentLoading) {
          setState(() {
            _loading = true;
          });
        } else if (state is PaymentInitial) {
          setState(() {
            _loading = false;
          });
        }
      },
      child: FormLayout(
        title: 'Add Payment',
        description: 'Track your payments',
        form: Column(
          children: [
            DropdownInput(
              labelText: 'Payment Type',
              items: const ['DEPOSIT', 'RENT'],
              initialValue: 'RENT',
              onChanged: (value) {
                setState(() {
                  paymentType = value;
                  _calculateTotalAmount();
                });
              },
              starter: 'Select Payment Type',
            ),
            if (paymentType == 'RENT')
              Row(
                children: [
                  Expanded(
                    child: DatePickerInput(
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
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DatePickerInput(
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
                  ),
                ],
              ),
            const SizedBox(height: 20),
            const SectionHeader(text: "Payment Details"),
            const SizedBox(height: 20),
            if (paymentType == 'RENT')
              TransactionEntry(
                labelText: 'Rent',
                controller: _rentController,
              ),
            if (paymentType == 'RENT')
              TransactionEntry(
                labelText: 'Food',
                controller: _foodController,
              ),
            if (paymentType == 'RENT')
              TransactionEntry(
                labelText: 'Electricity',
                controller: _electricityController,
              ),
            if (paymentType == 'RENT')
              TransactionEntry(
                labelText: 'Laundry',
                controller: _laundryController,
              ),
            if (paymentType == 'RENT')
              TransactionEntry(
                labelText: 'Miscellaneous',
                controller: _miscController,
              ),
            if (paymentType == 'DEPOSIT')
              TransactionEntry(
                labelText: 'Refundable',
                controller: _refundableController,
              ),
            if (paymentType == 'DEPOSIT')
              TransactionEntry(
                labelText: 'Non-Refundable',
                controller: _nonRefundableController,
              ),
            const SizedBox(height: 20),
            DropdownInput(
              labelText: 'Payment Method',
              items: const ['UPI', 'CARD', 'BANK TRANSFER', 'CASH'],
              onChanged: (value) {
                setState(() {
                  paymentMethod = value;
                });
              },
              initialValue: 'CASH',
              starter: 'Select Payment Method',
            ),
          ],
        ),
        buttonContainer: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const DescriptiveText(text: 'Total Amount: '),
                DescriptiveText(
                  text: '₹ ${totalAmount.toStringAsFixed(2)}',
                  color: MyConstants.text100,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            _loading
                ? const ProgressLoader()
                : LongButton(
                    text: 'Add Payment',
                    onPressed: () {
                      setState(() {
                        _loading = true;
                        _error = '';
                      });
                      if (_formKey.currentState!.validate()) {
                        if (totalAmount == 0) {
                          setState(() {
                            _loading = false;
                            _error = 'Total amount cannot be 0';
                          });
                        } else {
                          if (paymentType == 'RENT') {
                            context.read<PaymentBloc>().add(RentTransaction(
                                  bookingId: widget.bookingID,
                                  propertyId: widget.propertyID,
                                  amount: totalAmount,
                                  paymentMethod: paymentMethod,
                                  startDate: _startDateController.text,
                                  endDate: _endDateController.text,
                                  rent: _rentController.text,
                                  food: _foodController.text,
                                  electricity: _electricityController.text,
                                  laundry: _laundryController.text,
                                  misc: _miscController.text,
                                ));
                          } else if (paymentType == 'DEPOSIT') {
                            context.read<PaymentBloc>().add(DepositTransaction(
                                  bookingId: widget.bookingID,
                                  propertyId: widget.propertyID,
                                  amount: totalAmount,
                                  paymentMethod: paymentMethod,
                                  status: 'PAID',
                                  refundableAmount: _refundableController.text,
                                  nonRefundableAmount:
                                      _nonRefundableController.text,
                                ));
                          }
                        }
                      }
                    },
                  ),
            if (_error.isNotEmpty)
              const SizedBox(
                height: 10,
              ),
            if (_error.isNotEmpty) ErrorMessage(message: _error),
          ],
        ),
        formKey: _formKey,
      ),
    );
  }
}
