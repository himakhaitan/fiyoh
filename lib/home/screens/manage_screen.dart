import 'package:rentwise/common_widgets/section_header.dart';
import 'package:rentwise/home/widgets/property_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentwise/home/bloc/data_bloc.dart';
import 'package:rentwise/models/Property.dart'; // Assuming this is where Property class is defined

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  @override
  void initState() {
    super.initState();

    context.read<DataBloc>().add(GetProperties());
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
            BlocBuilder<DataBloc, DataState>(
              builder: (context, state) {
                if (state is DataSuccess) {
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
                } else if (state is DataFailure) {
                  return Center(
                    child: Text('Failed to load properties: ${state.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
