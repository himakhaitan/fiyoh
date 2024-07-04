import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/common_widgets/form_input.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/common_widgets/phone_number_input.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/layouts/form/form_layout.dart';

class AddNewTenantScreen extends StatefulWidget {
  const AddNewTenantScreen({super.key});

  @override
  State<AddNewTenantScreen> createState() => _AddNewTenantScreenState();
}

class _AddNewTenantScreenState extends State<AddNewTenantScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedFloor = "";
  String _selectedProperty = "";
  String _selectedRoom = "";
  String _error = "";
  List<String> roomItems = ["1"];

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      title: "Add new Tenant",
      description:
          "Welcome the new tenant to your property by adding their details below.",
      form: Column(
        children: [
          FormInput(
            labelText: "Email",
            hintText: "Tenant's Email",
            obscureText: false,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              return null;
            },
          ),
          PhoneNumberInput(
            labelText: 'Phone Number',
            hintText: "Tenant's Phone Number",
            controller: _phoneController,
            validator: (value) {
              return null;
            },
          ),
           DropdownInput(
            labelText: "Property",
            items: const ["1", "2"],
            onChanged: (value) {
              setState(() {
                _selectedProperty = value;
              });
            },
            starter: "Select Property",
          ),
          DropdownInput(
            labelText: "Floor Number",
            items: const ["1", "2"],
            onChanged: (value) {
              setState(() {
                _selectedFloor = value;
                roomItems = ["1", "2"];
                _selectedRoom = "Select Room";
              });
            },
            starter: "Select Floor",
          ),
          if (_selectedFloor.isNotEmpty && _selectedFloor != "Select Floor")
            DropdownInput(
              labelText: "Room Number",
              items: roomItems,
              onChanged: (value) {
                setState(() {
                  _selectedRoom = value;
                });
              },
              starter: "Select Room",
            ),
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: DescriptiveText(
                text: _error,
                color: MyConstants.redColor,
              ),
            ),
        ],
      ),
      buttonContainer: LongButton(
        text: "Add Tenant",
        onPressed: () {
          if (_formKey.currentState!.validate()) {

          }
        },
        buttonColor: MyConstants.accentColor,
        textColor: MyConstants.whiteColor,
      ),
      formKey: _formKey,
    );
  }
}
