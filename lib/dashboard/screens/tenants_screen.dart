import 'package:fiyoh/common_widgets/progress_loader.dart';
import 'package:fiyoh/tenant/bloc/tenant_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fiyoh/common_widgets/dropdown.dart';
import 'package:fiyoh/common_widgets/error_message.dart';
import 'package:fiyoh/property/bloc/property_bloc.dart';
import 'package:fiyoh/tenant/widgets/tenant_tile.dart';

class TenantsScreen extends StatefulWidget {
  const TenantsScreen({super.key});

  @override
  State<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends State<TenantsScreen> {
  List<String> propertyItems = [];
  List<String> propertyIds = [];
  List<String> tenantItems = [];
  String _error = "";
  bool _isLoading = false;
  String _selectedProperty = "";
  String _selectedPeriod = "Select Period";
  String _selectedStatus = "Select Status";

  @override
  void initState() {
    super.initState();

    final propertyState = context.read<PropertyBloc>().state;

    if (propertyState is! PropertyLoaded) {
      context.read<PropertyBloc>().add(GetProperties());
    } else {
      _updateProperties(propertyState);
    }
  }

  void _handleFilters() {
    setState(() {
      _isLoading = true;
    });
    if (_selectedPeriod == "Select Period" &&
        _selectedStatus == "Select Status") {
      setState(() {
        _error = "Please select a period and status";
      });
      return;
    }
  }

  void _updateProperties(PropertyLoaded state) {
    setState(() {
      propertyItems = state.properties.map((e) => e.propertyName).toList();
      propertyIds = state.properties.map((e) => e.id).toList();
      _error = "";
      _selectedProperty =
          (propertyItems.isNotEmpty) ? propertyItems.first : "Select Property";
      tenantItems = [];
    });
    if (propertyItems.isNotEmpty) {
      context.read<TenantBloc>().add(
            GetTenants(
              propertyId: state.properties.first.id,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PropertyBloc, PropertyState>(
          listener: (context, state) {
            if (state is PropertyLoaded) {
              _updateProperties(state);
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
        ),
        BlocListener<TenantBloc, TenantState>(
          listener: (context, state) {
            if (state is TenantLoaded) {
              setState(() {
                tenantItems = state.tenants;
                _error = "";
                _isLoading = false;
              });
            }
          },
        ),
      ],
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                DropdownInput(
                  labelText: "Property",
                  items: propertyItems,
                  initialValue: (propertyItems.isNotEmpty)
                      ? propertyItems.first
                      : "Select Property",
                  onChanged: (value) {
                    setState(() {
                      _selectedProperty = value;
                    });
                    if (value != "Select Property") {
                      final index = propertyItems.indexOf(_selectedProperty);
                      context.read<TenantBloc>().add(
                            GetTenants(
                              propertyId: propertyIds[index],
                            ),
                          );
                    }
                  },
                  starter: "Select Property",
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownInput(
                        labelText: "Period",
                        items: const ["Current Month", "Last Month"],
                        initialValue: _selectedPeriod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPeriod = value;
                          });
                          _handleFilters();
                        },
                        starter: "Select Period",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownInput(
                        labelText: "Payment Status",
                        initialValue: _selectedStatus,
                        items: const ["All", "Paid", "Unpaid"],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                          _handleFilters();
                        },
                        starter: "Select Status",
                      ),
                    ),
                  ],
                ),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextLinkButton(
                //     bgColor: Colors.grey[200]!,
                //     color: MyConstants.primaryColor,
                //     onPressed: () {
                //       _handleSearch();
                //     },
                //     icon: const Icon(
                //       Icons.search_outlined,
                //       color: MyConstants.primaryColor,
                //     ),
                //     text: "Search",
                //   ),
                // ),
              ],
            ),
          ),
          if (_error.isNotEmpty) ErrorMessage(message: _error),
          _isLoading
              ? const ProgressLoader()
              : (propertyItems.isEmpty)
                  ? const Center(child: Text("No property found"))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: tenantItems.length,
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
