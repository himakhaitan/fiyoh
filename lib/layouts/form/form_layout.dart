import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/header_text.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/layouts/widgets/custom_app_bar.dart';
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
      appBar: CustomAppBar(),
      backgroundColor: MyConstants.bg400,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: MyConstants.primary100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(text: title, color: MyConstants.text400),
                  const SizedBox(height: 12),
                  DescriptiveText(
                    text: description,
                    color: MyConstants.text400,
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
              decoration: BoxDecoration(
                color: MyConstants.bg400,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: buttonContainer,
            ),
          ],
        ),
      ),
    );
  }
}
