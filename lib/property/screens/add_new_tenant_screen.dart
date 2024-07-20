import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/common_widgets/error_message.dart';
import 'package:rentwise/common_widgets/form_input.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/common_widgets/phone_number_input.dart';
import 'package:rentwise/common_widgets/progress_loader.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/property/bloc/property_bloc.dart';
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

    final propertyState = context.read<PropertyBloc>().state;

    if (propertyState is! PropertyLoaded) {
      context.read<PropertyBloc>().add(GetProperties());
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  String _selectedFloor = "";
  String _selectedProperty = "";
  String _selectedRoom = "";
  String _error = "";
  bool _isLoading = false;
  List<String> propertyItems = [];
  List<String> floorItems = [];
  List<String> roomItems = ["1"];

  bool? _roomAvailable; // State variable to track room availability

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> _checkRoomAvailability(String propertyId, String roomId) async {
    try {
      DocumentSnapshot roomRef =
          await _firestore.collection('rooms').doc(roomId).get();
      if (roomRef.exists) {
        if (roomRef['occupancy'] > roomRef['tenants'].length) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyBloc, PropertyState>(
      listener: (context, state) {
        if (state is PropertyLoaded) {
          setState(() {
            _error = "";
            _isLoading = false;
            propertyItems =
                state.properties.map((e) => e.propertyName).toList();
          });
        } else if (state is PropertyLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is PropertyAPICompleted) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
        } else if (state is PropertyFailed) {
          setState(() {
            _isLoading = false;
            _error = state.error;
          });
        }
      },
      child: FormLayout(
        title: "Add new Tenant",
        description:
            "Welcome the new tenant to your property by adding their details below.",
        form: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormInput(
                    labelText: "First Name",
                    hintText: "First Name",
                    obscureText: false,
                    icon: Icons.person_2_outlined,
                    controller: _firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      if (value.length < 3) {
                        return 'First name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: FormInput(
                    labelText: "Last Name",
                    hintText: "Last Name",
                    obscureText: false,
                    controller: _lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      if (value.length < 3) {
                        return 'Last name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            FormInput(
              labelText: "Email",
              hintText: "Tenant's Email",
              obscureText: false,
              icon: Icons.alternate_email_outlined,
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                bool isValid =
                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
                if (!isValid) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            PhoneNumberInput(
              labelText: 'Phone Number',
              hintText: "Tenant's Phone Number",
              controller: _phoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length != 10) {
                  return 'Please enter a valid phone number';
                }
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
                  _error = "";
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
                onChanged: (value) async {
                  setState(() {
                    _isLoading = true;
                    _selectedRoom = value;
                  });

                  if (_selectedRoom != "Select Room") {
                    final state = context.read<PropertyBloc>().state;
                    if (state is PropertyLoaded) {
                      final selectedProperty = state.properties.firstWhere(
                          (property) =>
                              property.propertyName == _selectedProperty);

                      final selectedRoomID = state.properties
                          .firstWhere((property) =>
                              property.propertyName == _selectedProperty)
                          .rooms[_selectedFloor]!
                          .firstWhere(
                              (room) => room.roomNumber == _selectedRoom)
                          .id;

                      _roomAvailable = await _checkRoomAvailability(
                          selectedProperty.id, selectedRoomID);

                      if (_roomAvailable!) {
                        setState(() {
                          _error = "";
                          _isLoading = false;
                        });
                      } else {
                        setState(() {
                          _error = "Room is already occupied";
                          _isLoading = false;
                        });
                      }
                    }
                  }
                },
                starter: "Select Room",
              ),
          ],
        ),
        buttonContainer: Column(
          children: [
            _isLoading
                ? const ProgressLoader()
                : LongButton(
                    text: "Add Tenant",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedProperty == "Select Property" ||
                            _selectedFloor == "Select Floor" ||
                            _selectedRoom == "Select Room") {
                          setState(() {
                            _error = "Please select a property, floor and room";
                          });
                        } else if (_roomAvailable == false) {
                          setState(() {
                            _error = "Room is already occupied";
                          });
                        } else {
                          // Add tenant to the selected room
                          setState(() {
                            _error = "";
                          });
                          // Fetch the property id of the selected property
                          final state = context.read<PropertyBloc>().state;
                          if (state is PropertyLoaded) {
                            final selectedProperty = state.properties
                                .firstWhere((property) =>
                                    property.propertyName == _selectedProperty);

                            // Add tenant to the selected room
                            setState(() {
                              _error = "";
                            });

                            // Fetch the room id of the selected room

                            final selectedRoomID = state.properties
                                .firstWhere((property) =>
                                    property.propertyName == _selectedProperty)
                                .rooms[_selectedFloor]!
                                .firstWhere(
                                    (room) => room.roomNumber == _selectedRoom)
                                .id;

                            // context.read<PropertyBloc>().add(
                            //       AddTenant(
                            //         tenantEmail: _emailController.text,
                            //         tenantPhone: _phoneController.text,
                            //         tenantRoom: selectedRoomID,
                            //         propertyId: selectedProperty.propertyId,
                            //         tenantFirstName: _firstNameController.text,
                            //         tenantLastName: _lastNameController.text,
                            //       ),
                            //     );
                          }
                        }
                      }
                    },
                    buttonColor: MyConstants.accentColor,
                    textColor: MyConstants.whiteColor,
                  ),
            if (_error.isNotEmpty) const SizedBox(height: 10),
            if (_error.isNotEmpty) ErrorMessage(message: _error),
          ],
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
    final state = context.read<PropertyBloc>().state;

    if (state is PropertyLoaded) {
      final selectedProperty = state.properties
          .firstWhere((property) => property.propertyName == propertyName);
      return selectedProperty.rooms[floor]!
          .map((room) => {
                'roomId': room.id,
                'roomNumber': room.roomNumber,
              })
          .toList()
          .map((room) => room['roomNumber']!)
          .toList();
    } else {
      return [];
    }
  }
}
