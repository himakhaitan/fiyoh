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
  final Property property;

  AddProperty({required this.property});

  @override
  List<Object> get props => [property];
}

class AdjustProperty extends PropertyEvent {
  final String propertyId;

  final List<String> rooms;
  final String occupancy;

  AdjustProperty({required this.propertyId, required this.rooms, required this.occupancy});

  @override
  List<Object> get props => [propertyId, rooms, occupancy];
}

class AddTenant extends PropertyEvent {
  final String propertyId;
  final String tenantEmail;
  final String tenantPhone;
  final String tenantRoom;

  AddTenant({required this.propertyId, required this.tenantEmail, required this.tenantPhone, required this.tenantRoom});

  @override
  List<Object> get props => [propertyId, tenantEmail, tenantPhone, tenantRoom];
}