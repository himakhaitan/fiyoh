import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  final String propertyId;
  final String city;
  final String propertyName;
  final String propertyType;
  final String streetAddress;
  final String state;
  final String pincode;
  final Map<String, bool> amenities;
  final Map<String, bool> facilities;
  final Map<String, bool> paymentOptions;
  final List<String> rules;
  final Map<String, List<String>> rooms;

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
  });

  factory Property.fromJson(Map<String, dynamic> json, String id) {
    return Property(
      propertyId: id,
      city: json['city'],
      propertyName: json['property_name'],
      propertyType: json['property_type'],
      streetAddress: json['street_address'],
      state: json['state'],
      pincode: json['pincode'],
      amenities: json['amenities'],
      facilities: json['facilities'],
      paymentOptions: json['payment_options'],
      rules: json['rules'],
      rooms: json['rooms'],
    );
  }

  // forDocumentSnapshot 
  factory Property.fromDocument(DocumentSnapshot doc) {

    Map<String, bool> amenities = {};
    Map<String, bool> facilities = {};
    Map<String, bool> paymentOptions = {};
    List<String> rules = [];
    Map<String, List<String>> rooms = {};
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
    doc['rooms'].forEach((key, value) {
      rooms[key] = List<String>.from(value);
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
    );
  }
}