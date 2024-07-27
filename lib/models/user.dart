// Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiyoh/constants/enums.dart';

// User class
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String countryCode;
  final String phoneNumber;
  final String? profileUrl;
  final DateTime joinedAt;
  UserType? userType;
  List<String> properties;
 
  // Constructor
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCode,
    this.profileUrl,
    required this.joinedAt,
    required this.phoneNumber,
    required this.userType,
    required this.properties,
  });

  // Instanciate the User class from a DocumentSnapshot
  factory User.fromDocumentSnapshot(DocumentSnapshot doc) {
    List<String> properties = [];

    // Check if the properties field is not null
    if (doc['properties'] != null) {
      doc['properties'].forEach((value) {
        properties.add(value);
      });
    }

    // Return the User instance
    return User(
      id: doc.id,
      firstName: doc['first_name'],
      lastName: doc['last_name'],
      email: doc['email'],
      countryCode: doc['country_code'],
      phoneNumber: doc['phone_number'] ?? '',
      userType: UserTypeExtension.fromString(doc['user_type']),
      properties: properties,
      profileUrl: doc['photo_url'],
      joinedAt: doc['created_at'].toDate(),
    );
  }
}