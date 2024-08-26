import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/error_message.dart';
import 'package:fiyoh/common_widgets/form_input.dart';
import 'package:fiyoh/common_widgets/long_button.dart';
import 'package:fiyoh/common_widgets/progress_loader.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/layouts/form/form_layout.dart';
import 'package:fiyoh/models/property.dart';
import 'package:flutter/material.dart';

class AssignManagerScreen extends StatefulWidget {
  final Property property;
  const AssignManagerScreen({
    super.key,
    required this.property,
  });

  @override
  State<AssignManagerScreen> createState() => _AssignManagerScreenState();
}

class _AssignManagerScreenState extends State<AssignManagerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _error = '';
  bool _isLoading = false;
  String _success = '';

  void _assignManager() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _firestore
            .collection('users')
            .doc(_idController.text)
            .get()
            .then((value) async {
          if (!value.exists) {
            setState(() {
              _error = 'User with the given ID does not exist';
              _isLoading = false;
            });
          }
          await _firestore.collection('users').doc(_idController.text).update({
            'properties': FieldValue.arrayUnion([widget.property.id]) ,
          });
          await _firestore
              .collection('properties')
              .doc(widget.property.id)
              .update({
            'manager_id': _idController.text,
          });
          setState(() {
            _isLoading = false;
            _success = 'Manager assigned successfully';
          });
        });
      } catch (e) {
        setState(() {
          _error = 'An error occurred. Please try again later';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      title: 'Assign Manager',
      description: 'Get help managing your PG efficiently',
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInput(
            labelText: 'User ID',
            hintText: 'Enter the User ID of the Manager',
            obscureText: false,
            controller: _idController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid UserID';
              }
              return null;
            },
          ),
          const DescriptiveText(
            text:
                '*You can find the User ID of the Manager in the User Profile section of the Manager',
            fontSize: 14,
            color: MyConstants.infoDarkest,
          ),
          const SizedBox(height: 20),
          DescriptiveText(
            text: _success,
            color: MyConstants.greenColor,
            fontSize: 16,
          ),
        ],
      ),
      buttonContainer: Column(
        children: [
          if (_error.isNotEmpty) ErrorMessage(message: _error),
          _isLoading
              ? const ProgressLoader()
              : LongButton(
                  text: 'Assign Manager',
                  onPressed: () {
                    _assignManager();
                  },
                ),
        ],
      ),
      formKey: _formKey,
    );
  }
}
