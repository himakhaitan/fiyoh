import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/common_widgets/text_link_button.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/room/widgets/room_tile.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              DropdownInput(
                labelText: "Property",
                items: ["Green Homes Platina", "Krishna Kunj"],
                onChanged: (value) {},
                starter: "Select Property",
              ),
              DropdownInput(
                labelText: "Status",
                items: const ["All", "Empty", "Filled"],
                onChanged: (value) {},
                starter: "Select Status",
              ),
              Align(
                alignment: Alignment.center,
                child: TextLinkButton(
                  bgColor: Colors.grey[200]!,
                  color: MyConstants.primaryColor,
                  onPressed: () {},
                  icon: Icon(
                    Icons.search_outlined,
                    color: MyConstants.primaryColor,
                  ),
                  text: "Search",
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return RoomTile();
            },
          ),
        ),
      ],
    );
  }
}

