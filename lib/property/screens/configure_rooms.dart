import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/common_widgets/error_message.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/common_widgets/progress_loader.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:rentwise/common_widgets/text_link_button.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/property/bloc/property_bloc.dart';
import 'package:rentwise/layouts/form/form_layout.dart';
import 'package:rentwise/models/property.dart';
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
  List<Map<String, String>> addedRooms = [];
  String _selectedOccupancy = "";
  bool _isLoading = false;
  String _error = "";

  @override
  void initState() {
    super.initState();
  }

  List<String> _getRoomsOnFloor(String floor) {
    return widget.property.rooms[floor]!
        .map((room) => {
              'roomId': room.roomId,
              'roomNumber': room.roomNumber,
            })
        .toList()
        .map((room) => room['roomNumber']!)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyBloc, PropertyState>(
      listener: (context, state) {
        if (state is PropertyLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is PropertyLoaded) {
          setState(() {
            _error = "";
            _isLoading = false;
          });
        } else if (state is PropertyFailed) {
          setState(() {
            _error = state.error;
            _isLoading = false;
          });
        } else if (state is PropertyAPICompleted) {
          if (_error.isNotEmpty) {
            Navigator.pop(context);
          }
        }
      },
      child: FormLayout(
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

                  if (value != "Select Floor") {
                    roomItems = _getRoomsOnFloor(value);
                  } else {
                    roomItems = [];
                  }
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
            TextLinkButton(
              onPressed: () {
                if (_selectedRoom.isNotEmpty &&
                    _selectedRoom != "Select Room") {
                  String selectedRoomID = widget.property.rooms[_selectedFloor]!
                      .firstWhere(
                          (element) => element.roomNumber == _selectedRoom)
                      .roomId;

                  if (!addedRooms
                      .any((element) => element['roomId'] == selectedRoomID)) {
                    setState(() {
                      addedRooms.add({
                        'roomId': selectedRoomID,
                        'roomNumber': _selectedRoom,
                      });
                    });
                  }
                }
              },
              text: "Add Room",
            ),
            const SizedBox(
              height: 20,
            ),
            const SectionHeader(text: "Room Details"),
            const SizedBox(
              height: 10,
            ),
            DropdownInput(
              labelText: "Occupancy",
              items: const ["1", "2", "3", "4"],
              onChanged: (value) {
                setState(() {
                  _selectedOccupancy = value;
                });
              },
              starter: "Select Occupancy",
            ),
            const SizedBox(
              height: 10,
            ),
            const SectionHeader(text: "Rooms"),
            const SizedBox(
              height: 20,
            ),
            if (_isLoading) const ProgressLoader(),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DescriptiveText(
                            text: "Room ${addedRooms[index]['roomNumber']}",
                            color: MyConstants.primaryColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              addedRooms.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.close_outlined),
                        ),
                      ],
                    ),
                    const Divider(
                      color: MyConstants.greyColor,
                    ),
                  ],
                );
              },
              itemCount: addedRooms.length,
            ),
          ],
        ),
        buttonContainer: Column(
          children: [
            if (_error.isNotEmpty) ErrorMessage(message: _error),
            if (_error.isNotEmpty)
              const SizedBox(
                height: 10,
              ),
            _isLoading
                ? const ProgressLoader()
                : LongButton(
                    text: "Configure Room",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Call the bloc to update the rooms
                        context.read<PropertyBloc>().add(
                              AdjustProperty(
                                propertyId: widget.property.propertyId,
                                rooms: addedRooms
                                    .map((room) => room['roomId']!)
                                    .toList(),
                                occupancy: _selectedOccupancy,
                              ),
                            );
                      }
                    },
                    buttonColor: MyConstants.accentColor,
                    textColor: MyConstants.whiteColor,
                  ),
          ],
        ),
        formKey: _formKey,
      ),
    );
  }
}
