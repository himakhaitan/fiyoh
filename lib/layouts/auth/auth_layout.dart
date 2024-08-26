import 'package:fiyoh/layouts/widgets/custom_app_bar.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/header_text.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  bool showLeading = true;
  final String title;
  final String? subtitle;
  final String? description;
  final Widget container;
  final Widget button;
  AuthLayout({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    required this.container,
    required this.button,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showLeading: showLeading,
      ),
      resizeToAvoidBottomInset: false,
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
                  // SizedBox(height: 25,),
                  HeaderText(text: title, color: MyConstants.text400),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    HeaderText(text: subtitle!, color: MyConstants.text400),
                  const SizedBox(height: 12),
                  if (description != null && description!.isNotEmpty)
                    DescriptiveText(
                        text: description!, color: MyConstants.text400),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: container,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: button,
            ),
          ],
        ),
      ),
    );
  }
}
