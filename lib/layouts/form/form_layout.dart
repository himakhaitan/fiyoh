import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/header_text.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/layouts/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class FormLayout extends StatelessWidget {
  final String title;
  final String description;
  final Widget form;
  final Widget buttonContainer;
  final GlobalKey<FormState> formKey;

  const FormLayout({
    super.key,
    required this.title,
    required this.description,
    required this.form,
    required this.buttonContainer,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: MyConstants.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: MyConstants.accentColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(text: title, color: MyConstants.whiteColor),
                  const SizedBox(height: 12),
                  DescriptiveText(
                    text: description,
                    color: MyConstants.whiteColor,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: form,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: buttonContainer,
            ),
          ],
        ),
      ),
    );
  }
}
