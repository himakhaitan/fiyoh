// Import Statements
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:fiyoh/constants/enums.dart';
import 'package:fiyoh/models/property.dart';
import 'package:fiyoh/models/room.dart';
import 'package:fiyoh/utils/format_room_number.dart';

// Part Statements
part 'property_event.dart';
part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  // Firebase Instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Auth Instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register event handles in the constructor
  PropertyBloc() : super(PropertyInitial()) {
    // Register GetProperties event handler
    on<GetProperties>((event, emit) => _handleGetProperties(event, emit));

    // Register AddProperty event handler
    on<AddProperty>((event, emit) => _handleAddProperty(event, emit));

    // Register AdjustProperty event handler
    on<AdjustProperty>((event, emit) => _handleAdjustProperty(event, emit));

    // Register DeleteProperty event handler
    on<DeleteProperty>((event, emit) => _handleDeleteProperty(event, emit));

    // Register AddTenant event handler
    on<AddTenant>((event, emit) => _handleAddTenant(event, emit));
  }

  // Function to fetch properties from Firestore
  Future<List<Property>> _fetchProperties(String userId) async {
    // List to store properties
    List<Property> properties = [];

    try {
      // Fetch properties from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      List<String> propertyIds = List<String>.from(userData['properties']);

      // Iterate through each property id
      for (String propertyId in propertyIds) {
        // Fetch the property document
        DocumentSnapshot propertyDoc =
            await _firestore.collection('properties').doc(propertyId).get();

        // Map to store rooms by floor
        Map<String, List<Room>> rooms = {};

        // Check if the property document exists
        if (propertyDoc.exists) {
          Map<String, List<String>> roomIdsMap = {};

          // Iterate through each floor
          propertyDoc['rooms'].forEach((key, value) {
            roomIdsMap[key] = List<String>.from(value);
          });

          // Iterate through each floor
          for (String floor in roomIdsMap.keys) {
            // List to store rooms
            List<String> roomIds = roomIdsMap[floor]!;

            List<Room> roomList = [];

            // Iterate through each room id
            for (String roomId in roomIds) {
              DocumentSnapshot roomDoc =
                  await _firestore.collection('rooms').doc(roomId).get();

              if (roomDoc.exists) {
                roomList.add(Room.fromDocumentSnapshot(roomDoc));
              }
            }
            rooms[floor] = roomList;
          }
          // Add the property to the list
          properties.add(Property.fromDocumentSnapshot(propertyDoc, rooms));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return properties;
  }

  // Handle Add Tenant event
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
        'transactions': [],
        'status': 'ACTIVE',
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      // Create a new user with email id as the tenant email
      await _firestore.collection('users').doc(event.tenantEmail).set(
        {
          'first_name': event.tenantFirstName,
          'last_name': event.tenantLastName,
          'email': event.tenantEmail,
          'phone_number': event.tenantPhone,
          'user_type': 'TENANT',
          'bookings': FieldValue.arrayUnion([
            bookingRef.id,
          ]),
          'active_booking': bookingRef.id,
          'created_at': FieldValue.serverTimestamp(),
          'updated_at': FieldValue.serverTimestamp(),
        },
      );

      await _firestore.collection('rooms').doc(event.tenantRoom).update(
        {
          'tenants': FieldValue.arrayUnion([
            {
              'tenant_id': event.tenantEmail,
              'booking_id': bookingRef.id,
            }
          ]),
          'updated_at': FieldValue.serverTimestamp(),
        },
      );
      await _firestore.collection('users').doc(user.uid).update({
        'tenant_count': FieldValue.increment(1),
        'updated_at': FieldValue.serverTimestamp(),
      });
      emit(PropertyAPICompleted());
    } catch (e) {
      emit(PropertyFailed(error: e.toString()));
    }
  }

  // Handle GetProperties event
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

  // Handle AddProperty event
  Future<void> _handleAddProperty(
      AddProperty event, Emitter<PropertyState> emit) async {
    // Emit PropertyLoading state
    emit(PropertyLoading());
    try {
      // Get the current user
      final user = _auth.currentUser;

      // Check if the user is null
      if (user == null) {
        emit(PropertyFailed(error: 'User not found'));
        return;
      }

      // Create the property
      DocumentReference propertyRef =
          await _firestore.collection('properties').add({
        'property_name': event.propertyName,
        'city': event.city,
        'property_type': event.propertyType.value,
        'state': event.state,
        'street_address': event.streetAddress,
        'pincode': event.pincode,
        'owner_id': user.uid,
        'manager_id': null,
        'facilities': {
          'is_wifi': event.selectedFacilities[0],
          'is_laundry': event.selectedFacilities[1],
          'is_parking': event.selectedFacilities[2],
          'is_common_area': event.selectedFacilities[3],
          'is_gym': event.selectedFacilities[4],
          'is_cleaning': event.selectedFacilities[5],
          'is_cctv': event.selectedFacilities[6],
          'is_security': event.selectedFacilities[7],
          'is_power_backup': event.selectedFacilities[8],
          'is_food': event.selectedFacilities[9],
        },
        'payment_options': {
          'is_cash': event.selectedPaymentOptions[0],
          'is_upi': event.selectedPaymentOptions[1],
          'is_bank_transfer': event.selectedPaymentOptions[2],
          'is_debit_card': event.selectedPaymentOptions[3],
          'is_credit_card': event.selectedPaymentOptions[4],
        },
        'amenities': {
          'is_mattress': event.selectedAmenities[0],
          'is_wardrobe': event.selectedAmenities[1],
          'is_fridge': event.selectedAmenities[2],
          'is_table': event.selectedAmenities[3],
          'is_chair': event.selectedAmenities[4],
          'is_ac': event.selectedAmenities[5],
          'is_geyser': event.selectedAmenities[6],
          'is_tv': event.selectedAmenities[7],
          'is_washing_machine': event.selectedAmenities[8],
        },
        'rules': event.rules,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
        'rooms': {},
        'room_count': 0,
        'tenant_count': 0,
      });

      // Create the rooms
      String propertyId = propertyRef.id;
      Map<String, List<String>> roomsByFloor = {};
      int totalRooms = 0;

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
            totalRooms++;
          } catch (e) {
            // Error Creating Room
            roomNumber--;
          }
        }
      }

      // Update the property with the rooms
      await propertyRef.update({
        'rooms': roomsByFloor,
        'room_count': totalRooms,
      });

      // Update the user with the property
      DocumentReference userRef = _firestore.collection('users').doc(user.uid);
      await userRef.update({
        'properties': FieldValue.arrayUnion([propertyId]),
        'updated_at': FieldValue.serverTimestamp(),
      });

      // Add Property to the list
      List<Property> properties = await _fetchProperties(user.uid);

      // Emit PropertyLoaded state
      emit(PropertyLoaded(properties: properties));
    } catch (e) {
      emit(PropertyFailed(error: e.toString()));
    }
  }

  // Handle Configure Property event
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
                  'These rooms have more tenants than occupancy : ${roomNumbers.join(', ')}'));
        } else {
          emit(PropertyAPICompleted());
        }
      }
    } catch (e) {
      emit(PropertyFailed(error: e.toString()));
    }
  }

  // Handle Delete Property event
  Future<void> _handleDeleteProperty(
    DeleteProperty event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      _firestore.collection('users').doc(_auth.currentUser!.uid).update(
        {
          'properties': FieldValue.arrayRemove([event.propertyId]),
          'updated_at': FieldValue.serverTimestamp(),
        },
      );
      emit(PropertyAPICompleted());
    } catch (err) {
      emit(PropertyFailed(error: err.toString()));
    }
  }
}
