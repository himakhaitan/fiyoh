part of 'property_bloc.dart';

@immutable
sealed class PropertyEvent {}

class GetProperties extends PropertyEvent {
  GetProperties();
}

class ResetPropertyState extends PropertyEvent {
  ResetPropertyState();
}

class AddProperty extends PropertyEvent {
  final String propertyName;
  final String streetAddress;
  final String pincode;
  final String city;
  final String state;
  final PropertyType propertyType;
  final List<List<String>> floors;
  final List<String> rules;
  final List<bool> selectedFacilities;
  final List<bool> selectedPaymentOptions;
  final List<bool> selectedAmenities;

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

class RemoveTenant extends PropertyEvent {
  final Booking booking;

  RemoveTenant({required this.booking});

  @override
  List<Object> get props => [booking];
}

class AddTenant extends PropertyEvent {
  final String propertyId;
  final String tenantEmail;
  final String tenantPhone;
  final String tenantRoom;
  final String tenantFirstName;
  final String tenantLastName;
  final String gender;
  final DateTime joiningDate;

  AddTenant({
    required this.propertyId,
    required this.tenantEmail,
    required this.tenantPhone,
    required this.tenantRoom,
    required this.tenantFirstName,
    required this.tenantLastName,
    required this.gender,
    required this.joiningDate,
  });

  @override
  List<Object> get props => [propertyId, tenantEmail, tenantPhone, tenantRoom, gender, joiningDate];
}

class DeleteProperty extends PropertyEvent {
  final String propertyId;

  DeleteProperty({required this.propertyId});

  @override
  List<Object> get props => [propertyId];
}
