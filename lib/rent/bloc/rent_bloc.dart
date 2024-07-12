import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentwise/models/rent_data.dart';
import 'package:rentwise/models/transaction.dart' as transaction_model;
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentwise/models/property.dart';
import 'package:rentwise/models/room.dart';

part 'rent_event.dart';
part 'rent_state.dart';

class RentBloc extends Bloc<RentEvent, RentState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RentBloc() : super(RentInitial()) {
    on<GetRentData>((event, emit) => _handleGetRentData(event, emit));
  }

  Future<void> _handleGetRentData(
      GetRentData event, Emitter<RentState> emit) async {
    emit(RentLoading());
    try {
      // Get Authenticated User
      User? user = _auth.currentUser;
      if (user == null) {
        emit(RentFailed(error: 'User not authenticated'));
        return;
      }

      List<RentData> rentDataList = [];

      // Get User's list of properties
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      List<String> propertyIds = List<String>.from(userData['properties']);
      for (String propertyId in propertyIds) {
        DocumentSnapshot propertyDoc =
            await _firestore.collection('properties').doc(propertyId).get();

        Property property = Property.fromDocumentSnapshot(propertyDoc, {});
        QuerySnapshot roomsSnapshot = await _firestore
            .collection('properties')
            .doc(propertyId)
            .collection('rooms')
            .get();

        for (DocumentSnapshot roomDoc in roomsSnapshot.docs) {
          Room room = Room.fromDocumentSnapshot(roomDoc);
          // Calculate tenant count (if tenants exist)
          int tenantCount = room.tenants?.length ?? 0;
          // Exclude rooms with zero tenants
          if (tenantCount > 0) {
            // Check payment status (pending or paid)
            String roomStatus = 'Pending'; // Default to Pending

            // Check for paid transactions for all tenants in this room
            bool allPaid = true;
            List<Map<String, String>> tenantsData = [];
            for (Map<String, String>? tenant in room.tenants ?? []) {
              DocumentSnapshot userDoc = await _firestore
                  .collection('users')
                  .doc(tenant!['user_id'])
                  .get();
              if (!userDoc.exists) {
                emit(RentFailed(error: 'Error retrieving user data.'));
                continue;
              }
              String firstName = userDoc['first_name'];
              String lastName = userDoc['last_name'];
              // Get the data 3 months back
              DateTime currentDate = DateTime.now();
              DateTime threeMonthsAgo = DateTime(currentDate.year, currentDate.month - 2, 1);


              QuerySnapshot transactionsSnapshot = await _firestore
                  .collection('transactions')
                  .where('booking_id', isEqualTo: tenant['booking_id'])
                  .where('status', isEqualTo: 'SUCCESS')
                  .where('transaction_type', isEqualTo: 'RENT')
                  .where('rent_start_date', isGreaterThanOrEqualTo: threeMonthsAgo)
                  .where('rent_start_date', isLessThanOrEqualTo: currentDate)
                  .get();
              if (transactionsSnapshot.docs.isEmpty) {
                tenantsData.add({
                  'user_id': tenant['user_id']!,
                  'first_name': firstName,
                  'last_name': lastName,
                  'payment_status': 'Pending',
                  'booking_id': tenant['booking_id']!,
                  'payment_amount': '0',
                });
                allPaid = false;
              } else {
                // Assuming only one transaction for simplicity
                DocumentSnapshot transactionDoc =
                    transactionsSnapshot.docs.first;
                transaction_model.Transaction transaction =
                    transaction_model.Transaction.fromDocumentSnapshot(
                        transactionDoc);

                tenantsData.add({
                  'user_id': tenant['user_id']!,
                  'first_name': firstName,
                  'last_name': lastName,
                  'payment_status': 'Paid',
                  'booking_id': tenant['booking_id']!,
                  'payment_amount': transaction.amount.toString(),
                });
              }
            }

            if (allPaid) {
              roomStatus = 'Paid';
            } else {
              roomStatus = 'Pending';
            }
            // Add rent data for this room
            rentDataList.add(RentData(
              propertyId: property.propertyId,
              propertyName: property.propertyName,
              roomId: room.roomId,
              roomNumber: room.roomNumber,
              occupancy: room.occupancy,
              roomStatus: roomStatus,
              tenants: tenantsData,
            ));
          }
        }
      }
      emit(RentLoaded(rentDataList: rentDataList));
    } catch (e) {
      emit(RentFailed(error: e.toString()));
    }
  }
}
