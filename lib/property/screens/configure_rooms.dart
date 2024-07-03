import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:rentwise/common_widgets/text_link_button.dart';
import 'package:rentwise/constants/colours.dart';
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
            ),
          TextLinkButton(onPressed: () {}, text: "Add Room"),
          const SizedBox(height: 20,),
          const SectionHeader(text: "Room Details"),
          const SizedBox(height: 10,),
          DropdownInput(
            labelText: "Occupancy",
            items: const ["1", "2", "3", "4"],
            onChanged: (value) {},
            starter: "Select Occupancy",
          ),
          const SizedBox(height: 10,),
          const SectionHeader(text: "Rooms"),
          const SizedBox(height: 20,),
          const DescriptiveText(text: "No Rooms Selected", color: MyConstants.greyColor),
        ],
      ),
      buttonContainer: LongButton(
              text: "Configure Room",
              onPressed: () {
              },
              buttonColor: MyConstants.accentColor,
              textColor: MyConstants.whiteColor,
            ), 
      formKey: _formKey,
    );
  }
}
