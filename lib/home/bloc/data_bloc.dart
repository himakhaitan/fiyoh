import 'package:rentwise/models/Property.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DataBloc() : super(DataInitial()) {
    on<GetProperties>((event, emit) => _handleGetProperties(event, emit));
    on<AdjustRoomsDetails>((event, emit) => _handleConfigureRooms(event, emit));
  }

  Future<void> _handleConfigureRooms(
      AdjustRoomsDetails event, Emitter<DataState> emit) async {
    emit(DataLoading());
    String propertyId = event.property.propertyId;
    List<String> addedRooms = event.addedRooms;
    String occupancy = event.occupancy;

    // Convert Occupancy to int
    int occupancyInt = int.parse(occupancy);

    // Loop through addedRooms in chunks of 10 and call whereIn query
    // Update the rooms occupancy fields
    // Handle the last chunk to handle the remaining rooms
    for (int i = 0; i < addedRooms.length; i += 10) {
      List<String> chunk;
      if (i + 10 > addedRooms.length) {
        chunk = addedRooms.sublist(i, addedRooms.length);
      } else {
        chunk = addedRooms.sublist(i, i + 10);
      }
      await _firestore
          .collection('properties')
          .doc(propertyId)
          .collection('rooms')
          .where(FieldPath.documentId, whereIn: chunk)
          .get()
          .then(
        (roomDocs) {
          roomDocs.docs.forEach(
            (roomDoc) {
              roomDoc.reference.update(
                {
                  'occupancy': occupancyInt,
                  // Array with occupancy number of elements
                  'tenantId': List.filled(
                    occupancyInt,
                    {
                      'id': null,
                    },
                  ),
                },
              );
            },
          );
        },
      );
    }
  }

  Future<void> _handleGetProperties(
      GetProperties event, Emitter<DataState> emit) async {
    emit(DataLoading());
    String userId = _auth.currentUser!.uid;

    // Get the user's property ids
    await _firestore
        .collection('users')
        .doc(userId)
        .get()
        .then((userDoc) async {
      List<String> propertyIds =
          List<String>.from(userDoc.data()!['properties']);

      // Get the properties
      List<Property> properties = [];
      for (int i = 0; i < propertyIds.length; i++) {
        DocumentSnapshot propertyDoc =
            await _firestore.collection('properties').doc(propertyIds[i]).get();
        properties.add(Property.fromDocument(propertyDoc));
      }
      emit(DataSuccess(properties: properties));
    }).catchError((e) {
      emit(DataFailure(error: e.toString()));
    });
  }
}
