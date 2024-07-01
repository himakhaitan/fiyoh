import 'package:rentwise/common_widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/property/widgets/floor_input.dart';

class MultiInput<T> extends StatefulWidget {
  final String label;
  final String description;
  List<String> startRooms;
  List<String> endRooms;

  MultiInput({
    super.key,
    required this.label,
    required this.description,
    required this.startRooms,
    required this.endRooms,
  });

  @override
  State<MultiInput<T>> createState() => _MultiInputState<T>();
}

class _MultiInputState<T> extends State<MultiInput<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SectionHeader(text: widget.label),
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.startRooms.add('');
                    widget.endRooms.add('');
                  });
                },
                icon: const Icon(
                  Icons.add_circle_outline_outlined,
                  color: MyConstants.accentColor,
                  size: 26,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DescriptiveText(
            text: widget.description,
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.startRooms.length,
            itemBuilder: (context, index) {
              return FloorInput(
                key: ValueKey('FloorInput_$index'),
                floor: (index).toString(),
                startRoom: widget.startRooms[index],
                endRoom: widget.endRooms[index],
                onRemove: () {
                  setState(() {
                    widget.startRooms.removeAt(index);
                    widget.endRooms.removeAt(index);
                  });
                },
                onUpdateStartRoom: (String value) {
                  setState(() {
                    widget.startRooms[index] = value;
                  });
                },
                onUpdateEndRoom: (String value) {
                  setState(() {
                    widget.endRooms[index] = value;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
