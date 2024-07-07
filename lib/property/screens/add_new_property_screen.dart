import 'package:rentwise/common_widgets/checkbox_list.dart';
import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/common_widgets/form_input.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/property/widgets/multi_input.dart';
import 'package:rentwise/property/widgets/property_rules.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/layouts/form/form_layout.dart';
import 'package:rentwise/constants/property.dart';
import 'package:rentwise/services/property/property_service.dart';

class AddNewPropertyScreen extends StatefulWidget {
  const AddNewPropertyScreen({super.key});

  @override
  State<AddNewPropertyScreen> createState() => _AddNewPropertyScreenState();
}

class _AddNewPropertyScreenState extends State<AddNewPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _propertyNameController = TextEditingController();
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  String _selectedCity = "Select City";
  String _selectedState = "Select State";
  String _selectedPropertyType = "Select Property Type";
  List<String> startRooms = [];
  List<String> endRooms = [];
  List<String> rules = [];
  List<bool> selectedFacilities = List<bool>.filled(facilities.length, false);
  List<bool> selectedPaymentOptions =
      List<bool>.filled(paymentOptions.length, false);
  List<bool> selectedAmenities = List<bool>.filled(amenities.length, false);
  final PropertyService _propertyService = PropertyService();

  void onValueChangeCity(String newValue) {
    setState(() {
      _selectedCity = newValue;
    });
  }

  void onValueChangeState(String newValue) {
    setState(() {
      _selectedState = newValue;
    });
  }

  void onValueChangePropertyType(String newValue) {
    setState(() {
      _selectedPropertyType = newValue;
    });
  }

  void handleAddProperty() async {
    if (_formKey.currentState!.validate()) {
      await _propertyService.createProperty(
        _propertyNameController.text,
        _streetAddressController.text,
        _pincodeController.text,
        _selectedCity,
        _selectedState,
        _selectedPropertyType,
        startRooms,
        endRooms,
        rules,
        selectedFacilities,
        selectedPaymentOptions,
        selectedAmenities,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      title: "Add new Property",
      formKey: _formKey,
      description: "Fill in the property info to get started with your new PG",
      form: AddNewPropertyOptions(
        propertyNameController: _propertyNameController,
        streetAddressController: _streetAddressController,
        pincodeController: _pincodeController,
        selectedCity: _selectedCity,
        selectedState: _selectedState,
        selectedPropertyType:_selectedPropertyType,
        startRooms: startRooms,
        endRooms: endRooms,
        selectedFacilities: selectedFacilities,
        selectedPaymentOptions: selectedPaymentOptions,
        selectedAmenities: selectedAmenities,
        rules: rules,
        onCityChange: onValueChangeCity,
        onStateChange: onValueChangeState,
        onPropertyTypeChange: onValueChangePropertyType,
      ),
      buttonContainer: LongButton(
        text: "Add Property",
        onPressed: () {
          handleAddProperty();
        },
        buttonColor: MyConstants.accentColor,
        textColor: MyConstants.whiteColor,
      ),
    );
  }
}

class AddNewPropertyOptions extends StatefulWidget {
  final TextEditingController propertyNameController;
  final TextEditingController streetAddressController;
  final TextEditingController pincodeController;
  final String selectedCity;
  final String selectedState;
  final String selectedPropertyType;
  List<String> startRooms;
  List<String> endRooms;
  List<String> rules;
  List<bool> selectedFacilities;
  List<bool> selectedPaymentOptions;
  List<bool> selectedAmenities;
  final void Function(String) onCityChange;
  final void Function(String) onStateChange;
  final void Function(String) onPropertyTypeChange;

  AddNewPropertyOptions({
    super.key,
    required this.propertyNameController,
    required this.streetAddressController,
    required this.pincodeController,
    required this.selectedCity,
    required this.selectedState,
    required this.selectedPropertyType,
    required this.startRooms,
    required this.endRooms,
    required this.rules,
    required this.selectedFacilities,
    required this.selectedPaymentOptions,
    required this.selectedAmenities,
    required this.onCityChange,
    required this.onStateChange,
    required this.onPropertyTypeChange,
  });

  @override
  State<AddNewPropertyOptions> createState() => _AddNewPropertyOptionsState();
}

class _AddNewPropertyOptionsState extends State<AddNewPropertyOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormInput(
          labelText: "Property Name",
          hintText: "What's your property called?",
          obscureText: false,
          icon: Icons.home_work_outlined,
          controller: widget.propertyNameController,
          validator: (value) {
            return null;
          },
        ),
        FormInput(
          labelText: "Street Address",
          hintText: "Where is your property?",
          obscureText: false,
          icon: Icons.location_history_outlined,
          controller: widget.streetAddressController,
          validator: (value) {
            return null;
          },
        ),
        Row(
          children: [
            Expanded(
              child: DropdownInput(
                labelText: "City",
                items: cities,
                starter: "Select City",
                onChanged: widget.onCityChange,
              ),
            ),
            const SizedBox(
                width: 16), // Adjust spacing between dropdowns if needed
            Expanded(
              child: DropdownInput(
                labelText: "State",
                starter: "Select State",
                items: states,
                onChanged: widget.onStateChange,
              ),
            ),
          ],
        ),
        // postal_code
        FormInput(
          labelText: "Postal Code",
          hintText: "What's your Pincode?",
          obscureText: false,
          icon: Icons.location_on_outlined,
          controller: widget.pincodeController,
          validator: (value) {
            return null;
          },
        ),
        DropdownInput(
          labelText: "Property Type",
          items: propertyTypes,
          starter: "Select Property Type",
          onChanged: widget.onPropertyTypeChange,
        ),
        // Room Details including beds
        MultiInput<String>(
          label: "Add Floors",
          description: "Add rooms to your property",
          startRooms: widget.startRooms,
          endRooms: widget.endRooms,
        ),
        // Available Facilities
        CheckboxListFormField(
          options: facilities,
          onChanged: (index, select) {
            setState(() {
              widget.selectedFacilities[index] = select;
            });
          },
          selectedOptions: widget.selectedFacilities,
          label: "Available Facilities",
        ),

        // Payments method accepted
        CheckboxListFormField(
          options: paymentOptions,
          onChanged: (index, select) {
            setState(() {
              widget.selectedPaymentOptions[index] = select;
            });
          },
          selectedOptions: widget.selectedPaymentOptions,
          label: "Payment Methods",
        ),
        // Room Amenities
        CheckboxListFormField(
          options: amenities,
          onChanged: (index, select) {
            setState(() {
              widget.selectedAmenities[index] = select;
            });
          },
          selectedOptions: widget.selectedAmenities,
          label: "Room Amenities",
        ),
        PropertyRules<String>(
          label: "Property Rules",
          description: "Let us know your property rules",
          rules: widget.rules,
        )
      ],
    );
  }
}
