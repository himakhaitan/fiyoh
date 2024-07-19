import 'package:rentwise/layouts/widgets/custom_app_bar.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/header_text.dart';
import 'package:rentwise/constants/colours.dart';
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
      appBar: CustomAppBar(showLeading: showLeading,),
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
                  if (subtitle != null && subtitle!.isNotEmpty)
                    HeaderText(text: subtitle!, color: MyConstants.whiteColor),
                  const SizedBox(height: 12),
                  if (description != null && description!.isNotEmpty)
                    DescriptiveText(
                        text: description!, color: MyConstants.whiteColor),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
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
