import 'dart:ffi';

import 'package:rentwise/common_widgets/form_input.dart';
import 'package:rentwise/common_widgets/header_text.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/constants/colours.dart';

class FloorInput extends StatefulWidget {
  final String label;
  final String description;
  List<List<String>> floors;

  FloorInput({
    super.key,
    required this.label,
    required this.description,
    required this.floors,
  });

  @override
  State<FloorInput> createState() => _FloorInputState();
}

class _FloorInputState extends State<FloorInput> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(text: widget.label),
          const SizedBox(height: 8),
          DescriptiveText(
            text: widget.description,
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: FormInput(
                  hintText: 'Floor',
                  labelText: 'Floor',
                  obscureText: false,
                  controller: _floorController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              const DescriptiveText(
                text: ' - ',
                color: MyConstants.primaryColor,
                fontSize: 18,
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
                    return null;
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_floorController.text.isEmpty ||
                      _startController.text.isEmpty ||
                      _endController.text.isEmpty) {
                    return;
                  }
                  final floor = [
                    _floorController.text,
                    _startController.text,
                    _endController.text,
                  ];
                  setState(() {
                    widget.floors.add(floor);
                  });
                  _floorController.clear();
                  _startController.clear();
                  _endController.clear();
                },
                icon: const Icon(
                  Icons.add_circle_outline_outlined,
                  color: MyConstants.accentColor,
                  size: 26,
                ),
              ),
            ],
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return FloorTile(
                floor: widget.floors[index][0],
                start: widget.floors[index][1],
                end: widget.floors[index][2],
                onDelete: () {
                  setState(() {
                    widget.floors.removeAt(index);
                  });
                },
              );
            },
            itemCount: widget.floors.length,
            shrinkWrap: true,
          )
        ],
      ),
    );
  }
}

class FloorTile extends StatelessWidget {
  final String floor;
  final String start;
  final String end;
  final VoidCallback onDelete;
  const FloorTile({
    super.key,
    required this.floor,
    required this.start,
    required this.end,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 10),

        Center(
            child: DescriptiveText(
              text: floor,
              fontSize: 18,
              color: MyConstants.accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        const SizedBox(width: 20),
        const DescriptiveText(
          text: ' - ',
          color: MyConstants.primaryColor,
          fontSize: 18,
        ),
        const SizedBox(width: 20),
        DescriptiveText(
          text: start,
          color: MyConstants.primaryColor,
          fontSize: 18,
        ),
        const SizedBox(width: 20),
        const DescriptiveText(
          text: ' : ',
          color: MyConstants.primaryColor,
          fontSize: 18,
        ),
        const SizedBox(width: 20),
        DescriptiveText(
          text: end,
          color: MyConstants.primaryColor,
          fontSize: 18,
        ),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(
            Icons.remove_circle_outline_outlined,
            color: MyConstants.accentColor,
            size: 26,
          ),
        ),
      ],
    );
  }
}
