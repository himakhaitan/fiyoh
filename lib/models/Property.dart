import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentwise/models/room.dart';

class Property {
  final String propertyId;
  final String propertyName;
  final String propertyType;
  final String city;
  final String state;
  final String streetAddress;
  final String pincode;
  final String ownerID;
  final Map<String, bool> amenities;
  final Map<String, bool> facilities;
  final Map<String, bool> paymentOptions;
  final List<String> rules;
  final Map<String, List<Room>> rooms;
  
  Property({
    required this.propertyId,
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
    required this.ownerID,
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
      propertyId: doc.id,
      city: doc['city'],
      propertyName: doc['property_name'],
      propertyType: doc['property_type'],
      streetAddress: doc['street_address'],
      state: doc['state'],
      pincode: doc['pincode'],
      amenities: amenities,
      facilities: facilities,
      paymentOptions: paymentOptions,
      rules: rules,
      rooms: rooms,
      ownerID: doc['owner_id'],
    );
  }
}