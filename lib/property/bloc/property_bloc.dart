import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:rentwise/constants/enums.dart';
import 'package:rentwise/models/property.dart';
import 'package:rentwise/models/room.dart';

part 'property_event.dart';
part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PropertyBloc() : super(PropertyInitial()) {
    on<GetProperties>((event, emit) => _handleGetProperties(event, emit));
    on<AddProperty>((event, emit) => _handleAddProperty(event, emit));
    on<AdjustProperty>((event, emit) => _handleAdjustProperty(event, emit));
    on<AddTenant>((event, emit) => _handleAddTenant(event, emit));
  }

  Future<List<Property>> _fetchProperties(String userId) async {
    List<Property> properties = [];
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      List<String> propertyIds = List<String>.from(userData['properties']);

      for (String propertyId in propertyIds) {
        DocumentSnapshot propertyDoc =
            await _firestore.collection('properties').doc(propertyId).get();

        Map<String, List<Room>> rooms = {};

        if (propertyDoc.exists) {
          Map<String, List<String>> roomIdsMap = {};

          propertyDoc['rooms'].forEach((key, value) {
            roomIdsMap[key] = List<String>.from(value);
          });

          for (String floor in roomIdsMap.keys) {
            List<String> roomIds = roomIdsMap[floor]!;

            List<Room> roomList = [];

            for (String roomId in roomIds) {
              DocumentSnapshot roomDoc = await _firestore
                  .collection('rooms')
                  .doc(roomId)
                  .get();

              if (roomDoc.exists) {
                roomList.add(Room.fromDocumentSnapshot(roomDoc));
              }
            }
            rooms[floor] = roomList;
          }

          properties.add(Property.fromDocumentSnapshot(propertyDoc, rooms));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return properties;
  }

  Future<void> _handleAddTenant(
      AddTenant event, Emitter<PropertyState> emit) async {
    emit(PropertyLoading());
    try {
      final user = _auth.currentUser;

      if (user == null) {
        emit(PropertyFailed(error: 'Unauthenticated User'));
        return;
      }

      // Create a Booking
      DocumentReference bookingRef =
          await _firestore.collection('bookings').add({
        'property_id': event.propertyId,
        'room_id': event.tenantRoom,
        'tenant_id': event.tenantEmail,
        'check_in': FieldValue.serverTimestamp(),
        'check_out': null,
        'status': BOOKING_STATUS.CHECKED_IN.value,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
        'transactions': [],
      });

      // Create a new user with email id as the tenant email
      await _firestore.collection('users').doc(event.tenantEmail).set(
        {
          'first_name': event.tenantFirstName,
          'last_name': event.tenantLastName,
          'email': event.tenantEmail,
          'phone_number': event.tenantPhone,
          'user_type': USER_TYPE.TENANT.value,
          'bookings': FieldValue.arrayUnion([
            bookingRef.id,
          ]),
          'created_at': FieldValue.serverTimestamp(),
          'updated_at': FieldValue.serverTimestamp(),
        },
      );

      await _firestore
          .collection('rooms')
          .doc(event.tenantRoom)
          .update(
        {
          'tenants': FieldValue.arrayUnion([
            {
              'user_id': event.tenantEmail,
              'booking_id': bookingRef.id,
            }
          ]),
          'updated_at': FieldValue.serverTimestamp(),
        },
      );
      emit(PropertyAPICompleted());
    } catch (e) {
      emit(PropertyFailed(error: e.toString()));
    }
  }

  Future<void> _handleGetProperties(
      GetProperties event, Emitter<PropertyState> emit) async {
    emit(PropertyLoading());
    try {
      final user = _auth.currentUser;

      if (user == null) {
        emit(PropertyFailed(error: 'User not found'));
        return;
      }

      List<Property> properties = await _fetchProperties(user.uid);
      emit(PropertyLoaded(properties: properties));
    } catch (e) {
      emit(PropertyFailed(error: e.toString()));
    }
  }

  Future<void> _handleAddProperty(
      AddProperty event, Emitter<PropertyState> emit) async {
    emit(PropertyLoading());
    try {
      final user = _auth.currentUser;

      if (user == null) {
        emit(PropertyFailed(error: 'User not found'));
        return;
      }

      // Create the property
      DocumentReference propertyRef =
          await _firestore.collection('properties').add({
        'property_name': event.propertyName,
        'property_type': event.propertyType,
        'city': event.city,
        'state': event.state,
        'street_address': event.streetAddress,
        'pincode': event.pincode,
        'owner_id': user.uid,
        'facilities': {
          'isWifi': event.selectedFacilities[0],
          'isLaundry': event.selectedFacilities[1],
          'isParking': event.selectedFacilities[2],
          'isCommonArea': event.selectedFacilities[3],
          'isGym': event.selectedFacilities[4],
          'isCleaning': event.selectedFacilities[5],
          'isCctv': event.selectedFacilities[6],
          'isSecurity': event.selectedFacilities[7],
          'isPowerBackup': event.selectedFacilities[8],
          'isFood': event.selectedFacilities[9],
        },
        'payment_options': {
          'isCash': event.selectedPaymentOptions[0],
          'isUpi': event.selectedPaymentOptions[1],
          'isBankTransfer': event.selectedPaymentOptions[2],
          'isDebitCard': event.selectedPaymentOptions[3],
          'isCreditCard': event.selectedPaymentOptions[4],
        },
        'amenities': {
          'isMattress': event.selectedAmenities[0],
          'isWardrobe': event.selectedAmenities[1],
          'isFridge': event.selectedAmenities[2],
          'isTable': event.selectedAmenities[3],
          'isChair': event.selectedAmenities[4],
          'isAC': event.selectedAmenities[5],
          'isGeyser': event.selectedAmenities[6],
          'isTv': event.selectedAmenities[7],
          'isWashingMachine': event.selectedAmenities[8],
        },
        'rules': event.rules,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
        'rooms': {}
      });

      String propertyId = propertyRef.id;
      Map<String, List<String>> roomsByFloor = {};

      for (int i = 0; i < event.floors.length; i++) {
        int startRoomNumber = int.parse(event.floors[i][1]);
        int endRoomNumber = int.parse(event.floors[i][2]);
        int floor = int.parse(event.floors[i][0]);

        if (!roomsByFloor.containsKey(floor.toString())) {
          roomsByFloor[floor.toString()] = [];
        }

        for (int roomNumber = startRoomNumber;
            roomNumber <= endRoomNumber;
            roomNumber++) {
          // Create the room
          try {
            DocumentReference roomRef =
                await _firestore.collection('rooms').add({
              'room_number': formatRoomNumber(roomNumber),
              'floor': floor,
              'property_id': propertyId,
              'occupancy': 2,
              'tenants': [],
              'created_at': FieldValue.serverTimestamp(),
              'updated_at': FieldValue.serverTimestamp(),
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

      DocumentReference userRef = _firestore.collection('users').doc(user.uid);
      await userRef.update({
        'properties': FieldValue.arrayUnion([propertyId]),
        'updated_at': FieldValue.serverTimestamp(),
      });

      emit(PropertyAPICompleted());
    } catch (e) {
      print(e.toString());
      emit(PropertyFailed(error: e.toString()));
    }
  }

  Future<void> _handleAdjustProperty(
      AdjustProperty event, Emitter<PropertyState> emit) async {
    emit(PropertyLoading());
    try {
      int occupancyInt = int.parse(event.occupancy);
      List<String> roomNumbers = [];
      for (int i = 0; i < event.rooms.length; i += 10) {
        
        List<String> chunk;
        if (i + 10 > event.rooms.length) {
          chunk = event.rooms.sublist(i, event.rooms.length);
        } else {
          chunk = event.rooms.sublist(i, i + 10);
        }

        await _firestore
            .collection('rooms')
            .where(FieldPath.documentId, whereIn: chunk)
            .get()
            .then(
          (roomDocs) {
            roomDocs.docs.forEach(
              (roomDoc) {
                // Check if the room is already occupied
                if (roomDoc['tenants'].length > occupancyInt) {
                  roomNumbers.add(roomDoc['room_number']);
                }
                roomDoc.reference.update(
                  {
                    'occupancy': occupancyInt,
                    'updated_at': FieldValue.serverTimestamp(),
                  },
                );
              },
            );
          },
        );
        if (roomNumbers.isNotEmpty) {
          emit(PropertyFailed(
              error:
                  'These rooms have tenants inside: ${roomNumbers.join(', ')}'));
        } else {
          emit(PropertyAPICompleted());
        }
      }
    } catch (e) {
      emit(PropertyFailed(error: e.toString()));
    }
  }
}

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
