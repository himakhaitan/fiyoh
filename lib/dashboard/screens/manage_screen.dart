import 'package:rentwise/common_widgets/progress_loader.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:rentwise/property/bloc/property_bloc.dart';
import 'package:rentwise/property/widgets/property_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentwise/models/property.dart'; // Assuming this is where Property class is defined

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  @override
  void initState() {
    super.initState();

    final propertyState = context.read<PropertyBloc>().state;

    if (propertyState is! PropertyLoaded) {
      context.read<PropertyBloc>().add(GetProperties());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          children: [
            const SectionHeader(text: "Your Properties"),
            const SizedBox(height: 20),
            BlocBuilder<PropertyBloc, PropertyState>(
              builder: (context, state) {
                if (state is PropertyLoaded) {
                  List<Property> properties = state.properties;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      Property property = properties[index];
                      return PropertyTile(
                        property: property,
                      );
                    },
                  );
                } else if (state is PropertyFailed) {
                  return Center(
                    child: Text('Failed to load properties: ${state.error}'),
                  );
                } else {
                  return const ProgressLoader();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
