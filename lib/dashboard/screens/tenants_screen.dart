import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/common_widgets/error_message.dart';
import 'package:rentwise/common_widgets/text_link_button.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/property/bloc/property_bloc.dart';
import 'package:rentwise/tenant/widgets/tenant_tile.dart';

class TenantsScreen extends StatefulWidget {
  const TenantsScreen({super.key});

  @override
  State<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends State<TenantsScreen> {
  List<String> propertyItems = [];
  List<String> tenants = ["Himanshu"];
  String _error = "";
  bool _isLoading = false;
  String _selectedProperty = "";
  String _selectedPeriod = "";
  String _selectedStatus = "";

  @override
  void initState() {
    super.initState();

    final propertyState = context.read<PropertyBloc>().state;

    if (propertyState is! PropertyLoaded) {
      context.read<PropertyBloc>().add(GetProperties());
    }
  }

  void _handleSearch() {
    if (_selectedPeriod == "Select Period" ||
        _selectedProperty == "Select Property" ||
        _selectedStatus == "Select Status") {
      setState(() {
        _error = "Please select all fields";
      });
      return;
    }
    setState(() {
      _error = "";
      _isLoading = true;
      tenants = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyBloc, PropertyState>(
      listener: (context, state) {
        if (state is PropertyLoaded) {
          setState(() {
            propertyItems =
                state.properties.map((e) => e.propertyName).toList();
            _error = "";
            _isLoading = false;
          });
        } else if (state is PropertyLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is PropertyFailed) {
          setState(() {
            _error = state.error;
            _isLoading = false;
          });
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
                  items: ["Green Homes Platina", "Krishna Kunj"],
                  onChanged: (value) {
                    setState(() {
                      _selectedProperty = value;
                    });
                  },
                  starter: "Select Property",
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownInput(
                        labelText: "Period",
                        items: const ["Current Month", "Last Month"],
                        onChanged: (value) {
                          setState(() {
                            _selectedPeriod = value;
                          });
                        },
                        starter: "Select Period",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownInput(
                        labelText: "Payment Status",
                        items: const ["All", "Paid", "Unpaid"],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                        starter: "Select Status",
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextLinkButton(
                    bgColor: Colors.grey[200]!,
                    color: MyConstants.primaryColor,
                    onPressed: () {
                      _handleSearch();
                    },
                    icon: const Icon(
                      Icons.search_outlined,
                      color: MyConstants.primaryColor,
                    ),
                    text: "Search",
                  ),
                ),
              ],
            ),
          ),
          if (_error.isNotEmpty) ErrorMessage(message: _error),
          // _isLoading
          //     ? const ProgressLoader()
          //     : (propertyItems.isEmpty)
          //         ? const Center(child: Text("No property found"))
          //         : (tenants.isEmpty)
          //             ? const Center(child: Text("No tenants found")): 
          Expanded(
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const TenantTile();
                            },
                          ),
                        ),
        ],
      ),
    );
  }
}
