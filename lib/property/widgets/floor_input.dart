import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/form_input.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:flutter/material.dart';





class FloorInput extends StatefulWidget {
  final String floor;
  final String startRoom;
  final String endRoom;
  final ValueChanged<String> onUpdateStartRoom;
  final ValueChanged<String> onUpdateEndRoom;
  final VoidCallback onRemove;

  const FloorInput({
    super.key,
    required this.floor,
    required this.startRoom,
    required this.endRoom,
    required this.onUpdateStartRoom,
    required this.onUpdateEndRoom,
    required this.onRemove,
  });

  @override
  _FloorInputState createState() => _FloorInputState();
}

class _FloorInputState extends State<FloorInput> {
  late TextEditingController _startController;
  late TextEditingController _endController;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(text: widget.startRoom);
    _endController = TextEditingController(text: widget.endRoom);

    // Listen for changes in the start and end controllers
    _startController.addListener(_onStartRoomChanged);
    _endController.addListener(_onEndRoomChanged);
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  // Callback when the starting room number changes
  void _onStartRoomChanged() {
    widget.onUpdateStartRoom(_startController.text);
  }

  // Callback when the ending room number changes
  void _onEndRoomChanged() {
    widget.onUpdateEndRoom(_endController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: widget.onRemove,
            icon: const Icon(
              Icons.remove_circle_outline_outlined,
              color: MyConstants.accentColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 10),
          DescriptiveText(
            text: 'Floor ${widget.floor}',
            color: MyConstants.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: FormInput(
              hintText: 'Starting Room Number',
              labelText: 'Start',
              obscureText: false,
              controller: _startController,
              keyboardType: TextInputType.number,
              validator: (value) {

                if (value == null || value.isEmpty) {
                  return 'Please enter the starting room number';
                }
                if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                  return 'Room number must be a number';
                }
                if (value.length < 3) {
                  return 'Room number must be at least 3 characters';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 20),
          const DescriptiveText(
            text: ' : ',
            color: MyConstants.primaryColor,
            fontSize: 18,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: FormInput(
              hintText: 'Ending Room Number',
              labelText: 'End',
              obscureText: false,
              controller: _endController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the ending room number';
                }
                // Should only be digits
                if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                  return 'Room number must be a number';
                }
                if (value.length < 3) {
                  return 'Room number must be at least 3 characters';
                }

                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
