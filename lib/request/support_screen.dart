import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/dropdown.dart';
import 'package:fiyoh/common_widgets/error_message.dart';
import 'package:fiyoh/common_widgets/form_input.dart';
import 'package:fiyoh/common_widgets/long_button.dart';
import 'package:fiyoh/common_widgets/progress_loader.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/layouts/form/form_layout.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
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
      // Call the API to submit the support ticket
      try {
        await _firestore.collection('tickets').doc().set({
          'category': 'Owner > $category',
          'description': _descriptionController.text,
          'status': 'OPEN',
          'userId': _auth.currentUser!.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          success = "Your support ticket has been submitted successfully.";
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
      title: "Create Support Ticket",
      description:
          "If you're experiencing any issues or have questions, please fill out the form below to create a support ticket.",
      form: Column(
        children: [
          DropdownInput(
            labelText: "Category",
            items: const [
              "Account Issues",
              "Data Issues",
              "Feedback",
              "General",
              "Billing Issues",
              "Technical Issues",
              "Monthly Reminder"
              "Other",
            ],
            onChanged: (value) {
              setState(() {
                category = value;
              });
            },
            starter: "Select a category",
          ),
          FormInput(
            labelText: "Issue",
            obscureText: false,
            hintText: "Enter a detailed description of your request",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a detailed description of your request";
              }
              return null;
            },
            controller: _descriptionController,
            maxLines: 3,
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
