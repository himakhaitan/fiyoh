import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/common_widgets/error_message.dart';
import 'package:rentwise/common_widgets/progress_loader.dart';
import 'package:rentwise/models/room.dart';
import 'package:rentwise/property/bloc/property_bloc.dart';
import 'package:rentwise/room/widgets/room_tile.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List<String> propertyItems = [];
  String _error = "";
  bool _isLoading = false;
  String _selectedProperty = "";
  String _selectedStatus = "";
  List<Room> rooms = [];
  List<Room> allRooms = [];

  @override
  void initState() {
    super.initState();

    context.read<PropertyBloc>().add(GetProperties());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyBloc, PropertyState>(
      listener: (context, state) {
        if (state is PropertyLoaded) {
          setState(() {
            propertyItems =
                state.properties.map((e) => e.propertyName).toList();
            _error = "";
            _selectedProperty = (propertyItems.isNotEmpty)
                ? propertyItems.first
                : "Select Property";
            _selectedStatus = "All";

            allRooms = state.properties
                .where((element) => element.propertyName == _selectedProperty)
                .first
                .rooms
                .values
                .expand((element) => element)
                .toList();
            rooms = allRooms;
            _isLoading = false;
          });
        } else if (state is PropertyFailed) {
          setState(() {
            _error = state.error;
          });
        } else if (state is PropertyLoading) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                DropdownInput(
                  labelText: "Property",
                  items: propertyItems,
                  initialValue: (propertyItems.isNotEmpty)
                      ? propertyItems.first
                      : "Select Property",
                  onChanged: (value) {
                    setState(() {
                      _selectedProperty = value;
                      if (_selectedProperty != "Select Property") {
                        final currentState = context.read<PropertyBloc>().state;
                        if (currentState is PropertyLoaded) {
                          allRooms = currentState.properties
                              .where((element) =>
                                  element.propertyName == _selectedProperty)
                              .first
                              .rooms
                              .values
                              .expand((element) => element)
                              .toList();
                          rooms = allRooms;
                        }
                      } else {
                        allRooms = [];
                        rooms = [];
                      }
                    });
                  },
                  starter: "Select Property",
                ),
                DropdownInput(
                  labelText: "Status",
                  items: const ["All", "Empty", "Filled"],
                  initialValue:
                      (propertyItems.isNotEmpty) ? "All" : "Select Status",
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                      if (_selectedStatus != "Select Status") {
                        rooms = (value == "All")
                            ? allRooms
                            : allRooms
                                .where((element) => (value == "Empty")
                                    ? element.occupancy >
                                        element.tenants!.length
                                    : element.occupancy <=
                                        element.tenants!.length)
                                .toList();
                      } else {
                        rooms = [];
                      }
                    });
                  },
                  starter: "Select Status",
                ),
              ],
            ),
          ),
          if (_error.isNotEmpty) ErrorMessage(message: _error),
          _isLoading
              ? const ProgressLoader()
              : (rooms.isEmpty)
                  ? const Center(
                      child: Text("No rooms found."),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          return RoomTile(
                            room: rooms[index],
                            propertyName: _selectedProperty,
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
