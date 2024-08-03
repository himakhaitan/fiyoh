import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fiyoh/common_widgets/dropdown.dart';
import 'package:fiyoh/common_widgets/error_message.dart';
import 'package:fiyoh/common_widgets/progress_loader.dart';
import 'package:fiyoh/models/room.dart';
import 'package:fiyoh/property/bloc/property_bloc.dart';
import 'package:fiyoh/room/widgets/room_tile.dart';

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
  String _selectedStatus = "Select Status";
  List<Room> rooms = [];
  List<Room> allRooms = [];

  @override
  void initState() {
    super.initState();

    final propertyState = context.read<PropertyBloc>().state;

    if (propertyState is! PropertyLoaded) {
      context.read<PropertyBloc>().add(GetProperties());
    } else {
      _updateProperties(propertyState);
    }
  }

  void _updateProperties(PropertyLoaded state) {
    setState(() {
      propertyItems = state.properties.map((e) => e.propertyName).toList();
      _error = "";
      _selectedProperty =
          (propertyItems.isNotEmpty) ? propertyItems.first : "Select Property";
      _selectedStatus = "All";

      if (propertyItems.isNotEmpty) {
        allRooms = state.properties
            .where((element) => element.propertyName == _selectedProperty)
            .first
            .rooms
            .values
            .expand((element) => element)
            .toList();
        rooms = allRooms;
      } else {
        allRooms = [];
        rooms = [];
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyBloc, PropertyState>(
      listener: (context, state) {
        if (state is PropertyLoaded) {
          _updateProperties(state);
        } else if (state is PropertyFailed) {
          setState(() {
            _error = state.error;
          });
        } else if (state is PropertyLoading) {
          setState(() {
            _isLoading = true;
          });
        } else {
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
                      _selectedStatus = "All";
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
                  initialValue: _selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                      if (_selectedStatus != "Select Status") {
                        rooms = (value == "All")
                            ? allRooms
                            : allRooms
                                .where((element) => (value == "Empty")
                                    ? element.occupancy >
                                        element.tenants.length
                                    : element.occupancy <=
                                        element.tenants.length)
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
              : (propertyItems.isEmpty)
                  ? const Center(
                      child: Text("No properties found."),
                    )
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
