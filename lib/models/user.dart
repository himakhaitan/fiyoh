import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String userType;
  final List<String>? properties;
  final List<String>? bookings;
  final String? activeBooking;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.userType,
    this.properties,
    this.bookings,
    this.activeBooking,
  });

  factory User.fromDocumentSnapshot(DocumentSnapshot doc) {
    List<String>? properties = [];
    List<String>? bookings = [];
    String? activeBooking;

    if (doc['properties'] != null) {
      doc['properties'].forEach((value) {
        properties.add(value);
      });
    }

    if (doc['bookings'] != null) {
      doc['bookings'].forEach((value) {
        bookings.add(value);
      });
    }

    if (doc['active_booking'] != null) {
      activeBooking = doc['active_booking'];
    }

    return User(
      userId: doc.id,
      firstName: doc['first_name'],
      lastName: doc['last_name'],
      email: doc['email'],
      phoneNumber: doc['phone_number'],
      userType: doc['user_type'],
      properties: properties,
      bookings: bookings,
      activeBooking: activeBooking,
    );
  }
}