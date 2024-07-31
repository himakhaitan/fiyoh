import 'package:fiyoh/app_entry/auth/bloc/auth_bloc.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/info_item.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/constants/enums.dart';
import 'package:fiyoh/property/bloc/property_bloc.dart';
import 'package:fiyoh/models/property.dart';
import 'package:fiyoh/property/screens/configure_rooms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fiyoh/property/screens/property_detail_screen.dart';

class PropertyTile extends StatelessWidget {
  final Property property;

  const PropertyTile({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        splashColor: MyConstants.primaryColor.withOpacity(0.08),
        highlightColor: MyConstants.primaryColor.withOpacity(0.05),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => PropertyBloc(),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => PropertyBloc(),
                    ),
                    BlocProvider(
                      create: (context) => AuthBloc(),
                    ),
                  ],
                  child: PropertyDetailScreen(
                    property: property,
                  ),
                ),
              ),
            ),
          );
        },
        // inkwell configuration
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: MyConstants.colorGray600, width: 1),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: MyConstants.colorGray600,
                      width: 1.5,
                    ),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DescriptiveText(
                    text: property.propertyName,
                    fontSize: 18,
                    color: MyConstants.text100,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InfoItem(
                text: '${property.city}, ${property.state}',
                icon: Icons.location_on,
              ),
              const SizedBox(
                height: 10,
              ),
              InfoItem(
                text: property.propertyType.value,
                icon: Icons.home,
                color: (property.propertyType == PropertyType.female)
                    ? MyConstants.pinkMetallic
                    : (property.propertyType == PropertyType.male)
                        ? MyConstants.blueMetallic
                        : MyConstants.yellowMetallic,
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
                  IconButton.filledTonal(
                    icon: const Icon(
                      Icons.room_preferences_outlined,
                      color: MyConstants.primaryColor,
                      size: 20,
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.grey[200]),
                    ),
                    onPressed: () {
                      // Navigate to the configure rooms screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => PropertyBloc(),
                            child: ConfigureRooms(
                              property: property,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
