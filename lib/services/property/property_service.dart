import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String formatRoomNumber(int roomNumber) {
  // Convert roomNumber to string
  String roomNumberString = roomNumber.toString();

  // Check if the string length is less than 3
  if (roomNumberString.length < 3) {
    // Pad with zeros to make it at least 3 characters long
    roomNumberString = roomNumberString.padLeft(3, '0');
  }

  // Return the formatted room number string
  return roomNumberString;
}

class PropertyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a Property
  Future<void> createProperty(
    String propertName,
    String streetAddress,
    String pincode,
    String? city,
    String? state,
    String? propertyType,
    List<String> startRooms,
    List<String> endRooms,
    List<String> rules,
    List<bool> selectedFacilities,
    List<bool> selectedPaymentOptions,
    List<bool> selectedAmenities,
  ) async {
    // Add the property to the firestore
    try {
      // get the user id
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }
      String userId = user.uid;
      DocumentReference propertyRef =
          await _firestore.collection('properties').add({
        'owner_id': userId,
        'property_name': propertName,
        'street_address': streetAddress,
        'pincode': pincode,
        'city': city,
        'state': state,
        'property_type': propertyType,
        'facilities': {
          'iswifi': selectedFacilities[0],
          'islaundry': selectedFacilities[1],
          'isparking': selectedFacilities[2],
          'iscommonarea': selectedFacilities[3],
          'isgym': selectedFacilities[4],
          'iscleaning': selectedFacilities[5],
          'iscctv': selectedFacilities[6],
          'issecurity': selectedFacilities[7],
          'ispowerbackup': selectedFacilities[8],
          'isfood': selectedFacilities[9],
        },
        'payment_options': {
          'iscash': selectedPaymentOptions[0],
          'isupi': selectedPaymentOptions[1],
          'isbanktransfer': selectedPaymentOptions[2],
          'isdebitcard': selectedPaymentOptions[3],
          'iscreditcard': selectedPaymentOptions[4],
        },
        'amenities': {
          'ismattress': selectedAmenities[0],
          'iscupboard': selectedAmenities[1],
          'isfridge': selectedAmenities[2],
          'istable': selectedAmenities[3],
          'ischair': selectedAmenities[4],
          'isac': selectedAmenities[5],
          'isgeyser': selectedAmenities[6],
          'istv': selectedAmenities[7],
        },
        'rules': rules,
        'rooms': {},
      });
      String propertyId = propertyRef.id;

      Map<String, List<String>> roomsByFloor = {};

      for (int i = 0; i < startRooms.length; i++) {
        int startRoomNumber = int.parse(startRooms[i]);
        int endRoomNumber = int.parse(endRooms[i]);
        int floor = startRoomNumber ~/ 100;

        if (!roomsByFloor.containsKey(floor.toString())) {
          roomsByFloor[floor.toString()] = [];
        }

        for (int roomNumber = startRoomNumber;
            roomNumber <= endRoomNumber;
            roomNumber++) {
          // Create the room
          try {
            DocumentReference roomRef = await propertyRef.collection('rooms').add({
              'room_number': formatRoomNumber(roomNumber),
              'floor': floor,
            });
            roomsByFloor[floor.toString()]!.add(roomRef.id);
          } catch (e) {
            // Error Creating Room
            print('Error creating room: $e');
          }
        }
      }

      await propertyRef.update({
        'rooms': roomsByFloor,
      });

      DocumentReference userRef = _firestore.collection('users').doc(userId);
      await userRef.update({
        'properties': FieldValue.arrayUnion([propertyId]),
      });
    } catch (e) {
      // Error Creating Property
      print('Error creating property: $e');
    }
  }
}
