import 'package:flutter/material.dart';
import 'package:fiyoh/constants/colours.dart';

class DetailLayout extends StatelessWidget {
  final Widget body;
  final List<Widget>? actions;
  const DetailLayout({super.key, required this.body, this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstants.bg400,
      appBar: AppBar(
        backgroundColor: MyConstants.bg400,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
                color: MyConstants.primary100,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        actions: actions,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: body,
        ),
      ),
    );
  }
}
