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
