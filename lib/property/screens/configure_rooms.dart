import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/layouts/form/form_layout.dart';
import 'package:rentwise/models/Property.dart';
import 'package:flutter/material.dart';

class ConfigureRooms extends StatefulWidget {
  final Property property;
  const ConfigureRooms({super.key, required this.property});

  @override
  State<ConfigureRooms> createState() => _ConfigureRoomsState();
}

class _ConfigureRoomsState extends State<ConfigureRooms> {
  final _formKey = GlobalKey<FormState>();
  String _selectedFloor = "";
  String _selectedRoom = "";
  List<String> roomItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      title: 'Configure Rooms',
      description: 'Configure the rooms for ${widget.property.propertyName}',
      form: Column(
        children: [
          DropdownInput(
            labelText: "Select Floor",
            starter: "Select Floor",
            items: widget.property.rooms.keys.toList(),
            onChanged: (value) {
              setState(() {
                _selectedFloor = value;
                roomItems = widget.property.rooms[value]!.toList();
                _selectedRoom = "Select Room";
              });
            },
          ),
          if (_selectedFloor.isNotEmpty && _selectedFloor != "Select Floor")
            DropdownInput(
              labelText: "Select Room",
              starter: "Select Room",
              items: roomItems,
              onChanged: (value) {
                setState(() {
                  _selectedRoom = value;
                });
              },
            )
        ],
      ),
      buttonContainer: Container(), // Optionally add buttons here
      formKey: _formKey,
    );
  }
}
