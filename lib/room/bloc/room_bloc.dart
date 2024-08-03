import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiyoh/models/booking.dart';
import 'package:meta/meta.dart';
import 'package:fiyoh/models/tenant.dart';
import 'package:fiyoh/models/transaction.dart' as tmodel;
import 'package:fiyoh/models/room.dart';
part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RoomBloc() : super(RoomInitial()) {
    on<GetTenants>((event, emit) => _onGetTenants(event, emit));
  }

  Future<Tenant> fetchTenant(String userId, String bookingId) async {
    // Fetch transactions using transaction ids stored in the booking
    QuerySnapshot transactionSnapshot = await _firestore
        .collection('transactions')
        .where('booking_id', isEqualTo: bookingId)
        .get();
    
    // Create Transaction objects from the snapshot
    List<tmodel.Transaction> transactions = transactionSnapshot.docs
        .map((doc) => tmodel.Transaction.fromDocumentSnapshot(doc))
        .toList();

    // Fetch the booking details from the booking collection
    DocumentSnapshot bookingSnapshot = await _firestore
        .collection('bookings')
        .doc(bookingId)
        .get();

    // Create Booking Object from the snapshot
    Booking bookingObject = Booking.fromDocumentSnapshot(
        bookingSnapshot, transactions);

    // Fetch the tenant details from the tenant collection
    DocumentSnapshot tenantSnapshot =
        await _firestore.collection('users').doc(userId).get();

    // Create Tenant object from the snapshot
    Tenant tenant = Tenant.fromDocumentSnapshot(tenantSnapshot, bookingObject);

    return tenant;
  }

  void _onGetTenants(GetTenants event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    try {
      // loop through tenants inside event.room
      List<Tenant> tenants = [];
      for (var tenant in event.room.tenants) {
        // Get user_id and booking_id from the map
        String userId = tenant['tenant_id']!;
        String bookingId = tenant['booking_id']!;

        tenants.add(await fetchTenant(userId, bookingId));
      }
      emit(RoomLoaded(tenants: tenants));
    } catch (e) {
      emit(RoomFailed(error: e.toString()));
    }
  }
}
