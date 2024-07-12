import 'package:flutter/material.dart';
import 'package:rentwise/layouts/form/form_layout.dart';

class RentDetailScreen extends StatefulWidget {
  const RentDetailScreen({super.key});

  @override
  State<RentDetailScreen> createState() => _RentDetailScreenState();
}

class _RentDetailScreenState extends State<RentDetailScreen> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FormLayout(title: "", description: "description", form: Container(), buttonContainer: const Column(children: [],), formKey: _formKey);
  }
}