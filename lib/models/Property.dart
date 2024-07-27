import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiyoh/constants/enums.dart';
import 'package:fiyoh/models/room.dart';

class Property {
  final String id;
  final String propertyName;
  final PropertyType propertyType;
  final String city;
  final String state;
  final String streetAddress;
  final String pincode;
  final String ownerId;
  final int totalTenants;
  final int totalRooms;
  final DateTime createdAt;
  final String? managerId;
  final Map<String, bool> amenities;
  final Map<String, bool> facilities;
  final Map<String, bool> paymentOptions;
  final List<String> rules;
  final Map<String, List<Room>> rooms;
  
  Property({
    required this.id,
    required this.city,
    required this.propertyName,
    required this.propertyType,
    required this.streetAddress,
    required this.state,
    required this.pincode,
    required this.amenities,
    required this.facilities,
    required this.paymentOptions,
    required this.rules,
    required this.rooms,
    required this.ownerId,
    this.managerId,
    this.totalTenants = 0,
    this.totalRooms = 0,
    required this.createdAt,
  });

  // forDocumentSnapshot 
  factory Property.fromDocumentSnapshot(DocumentSnapshot doc, Map<String, List<Room>> rooms) {

    Map<String, bool> amenities = {};
    Map<String, bool> facilities = {};
    Map<String, bool> paymentOptions = {};
    List<String> rules = [];
    doc['amenities'].forEach((key, value) {
      amenities[key] = value;
    });
    doc['facilities'].forEach((key, value) {
      facilities[key] = value;
    });
    doc['payment_options'].forEach((key, value) {
      paymentOptions[key] = value;
    });
    doc['rules'].forEach((value) {
      rules.add(value);
    });

    
    return Property(
      id: doc.id,
      city: doc['city'],
      propertyName: doc['property_name'],
      propertyType: PropertyTypeExtension.fromString(doc['property_type'])!,
      streetAddress: doc['street_address'],
      state: doc['state'],
      pincode: doc['pincode'],
      amenities: amenities,
      facilities: facilities,
      paymentOptions: paymentOptions,
      rules: rules,
      rooms: rooms,
      ownerId: doc['owner_id'],
      managerId: doc['manager_id'],
      totalTenants: doc['tenant_count'] as int,
      totalRooms: doc['room_count'] as int,
      createdAt: doc['created_at'].toDate(),
    );
  }
}