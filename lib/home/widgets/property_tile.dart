import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/home/bloc/data_bloc.dart';
import 'package:rentwise/models/Property.dart';
import 'package:rentwise/property/screens/configure_rooms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertyTile extends StatelessWidget {
  final Property property;

  const PropertyTile({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: MyConstants.greyColor, width: 1),
      ),
      child: Column(
        children: [
          // Property Name
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: MyConstants.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DescriptiveText(
                text: property.propertyName,
                fontSize: 18,
                color: MyConstants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          IconItems(
            text: '${property.city}, ${property.state}',
            icon: Icons.location_on,
          ),
          const SizedBox(
            height: 10,
          ),
          IconItems(
            text: property.propertyType,
            icon: Icons.home,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const DescriptiveText(
                text: "Configure Rooms:",
                fontSize: 16,
                color: MyConstants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200]!, // Set the background color here
                  shape:
                      BoxShape.circle, // If you want the button to be circular
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.room_preferences_outlined,
                    color: MyConstants.primaryColor,
                    size: 20,
                  ),
                  onPressed: () {
                    // Navigate to the configure rooms screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => DataBloc(),
                          child: ConfigureRooms(
                            property: property,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IconItems extends StatelessWidget {
  final String text;
  final IconData icon;
  const IconItems({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: MyConstants.primaryColor.withOpacity(0.6),
          size: 20,
        ),
        const SizedBox(width: 10),
        DescriptiveText(
          text: text,
          fontSize: 16,
          color: MyConstants.primaryColor.withOpacity(0.6),
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
