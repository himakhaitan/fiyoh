import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/info_item.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/models/room.dart';
import 'package:fiyoh/room/bloc/room_bloc.dart';
import 'package:fiyoh/room/screens/room_detail_screen.dart';

class RoomTile extends StatelessWidget {
  final Room room;
  final String propertyName;

  const RoomTile({super.key, required this.room, required this.propertyName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyConstants.lightGreyColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MyConstants.primary100,
            ),
            child: Center(
              child: DescriptiveText(
                text: room.roomNumber,
                fontSize: 18,
                color: MyConstants.whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                InfoItem(
                  text: propertyName,
                  icon: Icons.apartment_outlined,
                ),
                InfoItem(
                  text: (room.occupancy > room.tenants!.length)
                      ? "Empty"
                      : "Filled",
                  icon: Icons.king_bed_outlined,
                  color: MyConstants.yellowMetallic,
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => RoomBloc(),
                    child: RoomDetailScreen(
                      room: room,
                      propertyName: propertyName,
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.navigate_next),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.grey[100]),
            ),
          ),
        ],
      ),
    );
  }
}
