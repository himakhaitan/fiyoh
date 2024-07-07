
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:rentwise/models/property.dart';

part 'property_event.dart';
part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PropertyBloc() : super(PropertyInitial()) {
    on<GetProperties>((event, emit) => _handleGetProperties(event, emit));
    on<AddProperty>((event, emit) => _handleAddProperty(event, emit));
    on<AdjustProperty>((event, emit) => _handleAdjustProperty(event, emit));
  }

  Future<List<Property>> _fetchProperties(String userId) async {
    List<Property> properties = [];
    await _firestore
        .collection('users')
        .doc(userId)
        .get()
        .then((userDoc) async {
      List<String> propertyIds =
          List<String>.from(userDoc.data()!['properties']);

      for (int i = 0; i < propertyIds.length; i++) {
        DocumentSnapshot propertyDoc =
            await _firestore.collection('properties').doc(propertyIds[i]).get();

        properties.add(Property.fromDocument(propertyDoc));
      }
    });

    return properties;
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

      List<Property> properties = await _fetchProperties(user.uid);

      emit(PropertyLoaded(properties: properties));
    } catch (e) {
      emit(PropertyFailed(error: e.toString()));
    }
  }

  Future<void> _handleAdjustProperty(
      AdjustProperty event, Emitter<PropertyState> emit) async {
    emit(PropertyLoading());
    try {
      int occupancyInt = int.parse(event.occupancy);

      for (int i = 0; i < event.rooms.length; i += 10) {
        List<String> chunk;
        if (i + 10 > event.rooms.length) {
          chunk = event.rooms.sublist(i, event.rooms.length);
        } else {
          chunk = event.rooms.sublist(i, i + 10);
        }

        await _firestore
            .collection('properties')
            .doc(event.propertyId)
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
                    'tenants': [],
                  },
                );
              },
            );
          },
        );
      }
    } catch (e) {
      emit(PropertyFailed(error: e.toString()));
    }
  }
}
