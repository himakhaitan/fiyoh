import 'package:bloc/bloc.dart';
import 'package:fiyoh/models/booking.dart';
import 'package:meta/meta.dart';
import 'package:fiyoh/models/tenant.dart';
import 'package:fiyoh/models/transaction.dart' as tmodel;
import 'package:cloud_firestore/cloud_firestore.dart';
part 'tenant_event.dart';
part 'tenant_state.dart';

class TenantBloc extends Bloc<TenantEvent, TenantState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TenantBloc() : super(TenantInitial()) {
    on<GetTenants>((event, emit) => _handleGetTenants(event, emit));
  }

  Future<Tenant> fetchTenant(DocumentSnapshot booking) async {
    String tenantId = booking['tenant_id'];

    // Fetch transactions using transaction ids stored in the booking
    QuerySnapshot transactionSnapshot = await _firestore
        .collection('transactions')
        .where('booking_id', isEqualTo: booking.id)
        .get();

    // Create Transaction objects from the snapshot
    List<tmodel.Transaction> transactions = transactionSnapshot.docs
        .map((doc) => tmodel.Transaction.fromDocumentSnapshot(doc))
        .toList();
    // Create Booking Object from the snapshot
    Booking bookingObject = Booking.fromDocumentSnapshot(booking, transactions);

    // Fetch the tenant details from the tenant collection
    DocumentSnapshot tenantSnapshot =
        await _firestore.collection('users').doc(tenantId).get();

    // Create Tenant object from the snapshot
    Tenant tenant = Tenant.fromDocumentSnapshot(tenantSnapshot, bookingObject);

    return tenant;
  }

  Future<void> _handleGetTenants(
      GetTenants event, Emitter<TenantState> emit) async {
    emit(TenantLoading());
    try {
      QuerySnapshot bookingSnapshot = await _firestore
          .collection('bookings')
          .where('property_id', isEqualTo: event.propertyId)
          .where('status', isEqualTo: 'ACTIVE')
          .get();

      List<Tenant> tenants = [];
      // Loop through the snapshot and create a list of tenants andcall a function fetchTenant that returns Tenants
      for (var booking in bookingSnapshot.docs) {
        tenants.add(await fetchTenant(booking));
      }
      emit(TenantLoaded(tenants: tenants, propertyId: event.propertyId));
    } catch (e) {
      print(e);
      emit(TenantFailed(error: "Failed to load tenants"));
    }
  }
}
