import 'package:rentwise/common_widgets/section_header.dart';
import 'package:flutter/material.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          children: [
            const SectionHeader(text: "Rent Details"),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}
