import 'package:fiyoh/common_widgets/progress_loader.dart';
import 'package:fiyoh/models/tenant.dart';
import 'package:fiyoh/models/transaction.dart';
import 'package:fiyoh/property/widgets/no_property.dart';
import 'package:fiyoh/tenant/bloc/tenant_bloc.dart';
import 'package:fiyoh/tenant/widgets/no_tenant.dart';
import 'package:fiyoh/utils/date_handler.dart';
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
  List<Tenant> tenantBuffer = [];
  List<Tenant> tenantItems = [];
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
    // If the user selects "All" and no specific period
    if (_selectedStatus == "All" && _selectedPeriod == "Select Period") {
      setState(() {
        tenantItems = tenantBuffer; // Show all tenants
        _error = "";
        _isLoading = false;
      });
      return;
    }

    if (_selectedPeriod == "Select Period" ||
        _selectedStatus == "Select Status") {
      setState(() {
        _error = "Please select a period and status";
        _isLoading = false;
      });
      return;
    }
    DateTime now = DateTime.now();
    DateTime startOfMonth;
    DateTime endOfMonth;

    if (_selectedPeriod == "Current Month") {
      startOfMonth = getFirstDayOfMonth(now);
      endOfMonth = getLastDayOfMonth(now);
    } else if (_selectedPeriod == "Last Month") {
      startOfMonth = DateTime(now.year, now.month - 1, 1);
      endOfMonth = DateTime(now.year, now.month, 0);
    } else {
      setState(() {
        _error = "Please select a valid period";
        _isLoading = false;
      });
      return;
    }

    List<Tenant> filteredTenants = tenantBuffer.where((tenant) {
      // Filter transactions based on the period
      List<Transaction> transactionsInPeriod =
          tenant.activeBooking.transactions.where((transaction) {
        bool withinPeriod =
            (transaction.startDate?.isAtSameMomentAs(startOfMonth) ?? false) &&
                (transaction.endDate?.isAtSameMomentAs(endOfMonth) ?? false);
        return withinPeriod;
      }).toList();

      if (_selectedStatus == "Paid") {
        return transactionsInPeriod.isNotEmpty;
      } else if (_selectedStatus == "Unpaid") {
        return transactionsInPeriod.isEmpty;
      } else if (_selectedStatus == "All") {
        return true; // Include all tenants regardless of payment status
      } else {
        return false;
      }
    }).toList();

    if (filteredTenants.isEmpty) {
      setState(() {
        tenantItems = [];
        _isLoading = false;
      });
    } else {
      setState(() {
        tenantItems = filteredTenants;
        _error = "";
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _updateProperties(PropertyLoaded state) {
    setState(() {
      propertyItems = state.properties.map((e) => e.propertyName).toList();
      propertyIds = state.properties.map((e) => e.id).toList();
      _error = "";
      _selectedProperty =
          (propertyItems.isNotEmpty) ? propertyItems.first : "Select Property";
      tenantBuffer = [];
      tenantItems = [];
    });
    if (propertyItems.isNotEmpty) {
      // Check if TenantBloc has already loaded tenants for the first property
      final tenantState = context.read<TenantBloc>().state;
      if (tenantState is! TenantLoaded) {
        context.read<TenantBloc>().add(
              GetTenants(
                propertyId: propertyIds.first,
              ),
            );
      } else {
        if (tenantState.propertyId != propertyIds.first) {
          context.read<TenantBloc>().add(
                GetTenants(
                  propertyId: propertyIds.first,
                ),
              );
        } else {
          setState(() {
            tenantItems = [];
            tenantBuffer = tenantState.tenants;
          });
        }
      }
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
              setState(() {
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
                    } else {
                      setState(() {
                        tenantItems = [];
                        _error = "";
                      });
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
                            _error = "";
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
                            _error = "";
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
                  ? const NoProperty()
                  : (tenantItems.isEmpty &&
                          _selectedProperty != "Select Property" &&
                          _selectedPeriod != "Select Period" &&
                          _selectedStatus != "Select Status")
                      ? const NoTenant()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: tenantItems.length,
                            itemBuilder: (context, index) {
                              return TenantTile(tenant: tenantItems[index]);
                            },
                          ),
                        ),
        ],
      ),
    );
  }
}
