import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/dropdown.dart';
import 'package:fiyoh/common_widgets/error_message.dart';
import 'package:fiyoh/common_widgets/long_button.dart';
import 'package:fiyoh/common_widgets/progress_loader.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/layouts/form/form_layout.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  String category = "";
  String error = "";
  String success = "";

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Submit the form
      setState(() {
        error = "";
        success = "";
        isLoading = true;
      });
      // Call the API to submit the Report ticket
      try {
        await _firestore.collection('tickets').doc().set({
          'category': 'Request > Owner > Report > $category',
          'status': 'OPEN',
          'userId': _auth.currentUser!.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          success = "Your report request has been submitted successfully. We will send you an email with the final statements in the next 24-48 hours.";
          isLoading = false;
        });
      } catch (err) {
        setState(() {
          error = "An error occurred. Please try again later.";
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      title: "Request Final Statements",
      description:
          "Select a date range to generate and view your final statements.",
      form: Column(
        children: [
          DropdownInput(
            labelText: "Category",
            items: const [
              "Last Month",
              "Last 3 Months",
              "Last 6 Months",
              "Last Year",
              "Last Financial Year",
            ],
            onChanged: (value) {
              setState(() {
                category = value;
              });
            },
            starter: "Select Duration",
          ),
          const SizedBox(height: 20),
          DescriptiveText(
            text: success,
            color: MyConstants.greenColor,
            fontSize: 16,
          ),
        ],
      ),
      buttonContainer: Column(
        children: [
          if (error.isNotEmpty) ErrorMessage(message: error),
          isLoading
              ? const ProgressLoader()
              : LongButton(
                  text: "Submit Request",
                  textColor: MyConstants.whiteColor,
                  buttonColor: MyConstants.primaryColor,
                  onPressed: () {
                    handleSubmit();
                  },
                ),
        ],
      ),
      formKey: _formKey,
    );
  }
}
