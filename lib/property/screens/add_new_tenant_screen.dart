import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/common_widgets/form_input.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/common_widgets/phone_number_input.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/home/bloc/property_bloc.dart';
import 'package:rentwise/layouts/form/form_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewTenantScreen extends StatefulWidget {
  const AddNewTenantScreen({super.key});

  @override
  State<AddNewTenantScreen> createState() => _AddNewTenantScreenState();
}

class _AddNewTenantScreenState extends State<AddNewTenantScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure this is called after the widget is fully built
    context.read<PropertyBloc>().add(GetProperties());
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedFloor = "";
  String _selectedProperty = "";
  String _selectedRoom = "";
  String _error = "";
  List<String> propertyItems = [];
  List<String> floorItems = [];
  List<String> roomItems = ["1"];

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyBloc, PropertyState>(
      listener: (context, state) {
        if (state is PropertyLoaded) {
          setState(() {
            propertyItems =
                state.properties.map((e) => e.propertyName).toList();
          });
        } else {}
      },
      child: FormLayout(
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
              items: propertyItems,
              onChanged: (value) {
                setState(() {
                  _selectedProperty = value;
                  if (_selectedProperty != "Select Property") {
                    floorItems = _getFloorsForProperty(value);
                  } else {
                    floorItems = [];
                  }
                  _selectedFloor = "Select Floor";
                  _selectedRoom = "Select Room";
                });
              },
              starter: "Select Property",
            ),
            if (_selectedProperty.isNotEmpty &&
                _selectedProperty != "Select Property")
              DropdownInput(
                labelText: "Floor Number",
                items: floorItems,
                onChanged: (value) {
                  setState(() {
                    _selectedFloor = value;
                    if (_selectedFloor != "Select Floor") {
                      roomItems = _getRoomsOnFloor(_selectedProperty, value);
                    } else {
                      roomItems = [];
                    }
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
              if (_selectedProperty == "Select Property" ||
                  _selectedFloor == "Select Floor" ||
                  _selectedRoom == "Select Room") {
                setState(() {
                  _error = "Please select a property, floor and room";
                });
              } else {
                // Add tenant to the selected room
                setState(() {
                  _error = "";
                });
                // Fetch the property id of the selected property
                final state = context.read<PropertyBloc>().state;
                if (state is PropertyLoaded) {
                  final selectedProperty = state.properties.firstWhere(
                      (property) => property.propertyName == _selectedProperty);

                  // Add tenant to the selected room
                  setState(() {
                    _error = "";
                  });

                  context.read<PropertyBloc>().add(
                        AddTenant(
                          tenantEmail: _emailController.text,
                          tenantPhone: _phoneController.text,
                          tenantRoom: _selectedRoom,
                          propertyId: selectedProperty.propertyId,
                        ),
                      );
                  
                  Navigator.pop(context);
                }
              }
            }
          },
          buttonColor: MyConstants.accentColor,
          textColor: MyConstants.whiteColor,
        ),
        formKey: _formKey,
      ),
    );
  }

  List<String> _getFloorsForProperty(String propertyName) {
    // Logic to get floors for the selected property
    final state = context.read<PropertyBloc>().state;

    if (state is PropertyLoaded) {
      final selectedProperty = state.properties
          .firstWhere((property) => property.propertyName == propertyName);
      return selectedProperty.rooms.keys.toList();
    } else {
      return [];
    }
  }

  List<String> _getRoomsOnFloor(String propertyName, String floor) {
    // Logic to get rooms on the selected floor
    final state = context.read<PropertyBloc>().state;

    if (state is PropertyLoaded) {
      final selectedProperty = state.properties
          .firstWhere((property) => property.propertyName == propertyName);
      return selectedProperty.rooms[floor]!.toList();
    } else {
      return [];
    }
  }
}
