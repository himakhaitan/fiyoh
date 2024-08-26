// Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiyoh/models/booking.dart';

// Tenant Class
class Tenant {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String countryCode;
  final String phoneNumber;
  final Booking activeBooking;

  // Constructor
  Tenant({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
    required this.activeBooking,
    required this.gender,
  });

  // Instanciate the Tenant class from a DocumentSnapshot
  factory Tenant.fromDocumentSnapshot(DocumentSnapshot doc, Booking activeBooking) {

    return Tenant(
      id: doc.id,
      firstName: doc['first_name'],
      lastName: doc['last_name'],
      email: doc['email'],
      gender: doc['gender'],
      countryCode: doc['country_code'],
      phoneNumber: doc['phone_number'] ?? '',
      activeBooking: activeBooking,
    );
  }
}