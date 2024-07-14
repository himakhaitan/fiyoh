part of 'property_bloc.dart';

@immutable
sealed class PropertyEvent {
  @override
  List<Object> get props => [];
}

class GetProperties extends PropertyEvent {
  GetProperties();

  @override
  List<Object> get props => [];
}

class AddProperty extends PropertyEvent {
  String propertyName;
  String streetAddress;
  String pincode;
  String city;
  String state;
  String propertyType;
  List<List<String>> floors;
  List<String> rules;
  List<bool> selectedFacilities;
  List<bool> selectedPaymentOptions;
  List<bool> selectedAmenities;

  AddProperty({
    required this.propertyName,
    required this.streetAddress,
    required this.pincode,
    required this.city,
    required this.state,
    required this.propertyType,
    required this.floors,
    required this.rules,
    required this.selectedFacilities,
    required this.selectedPaymentOptions,
    required this.selectedAmenities,
  });

  @override
  List<Object> get props => [
        propertyName,
        streetAddress,
        pincode,
        city,
        state,
        propertyType,
        floors,
        rules,
        selectedFacilities,
        selectedPaymentOptions,
        selectedAmenities,
      ];
}

class AdjustProperty extends PropertyEvent {
  final String propertyId;

  final List<String> rooms;
  final String occupancy;

  AdjustProperty(
      {required this.propertyId, required this.rooms, required this.occupancy});

  @override
  List<Object> get props => [propertyId, rooms, occupancy];
}

class AddTenant extends PropertyEvent {
  final String propertyId;
  final String tenantEmail;
  final String tenantPhone;
  final String tenantRoom;
  final String tenantFirstName;
  final String tenantLastName;

  AddTenant({
    required this.propertyId,
    required this.tenantEmail,
    required this.tenantPhone,
    required this.tenantRoom,
    required this.tenantFirstName,
    required this.tenantLastName,
  });

  @override
  List<Object> get props => [propertyId, tenantEmail, tenantPhone, tenantRoom];
}
