import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:rentwise/models/room.dart';
part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RoomBloc() : super(RoomInitial()) {
    on<GetTenants>((event, emit) => _onGetTenants(event, emit));
  }

  void _onGetTenants(GetTenants event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    try {
      // loop through tenants inside event.room
      List<String> tenants = [];
      event.room.tenants!.forEach((tenant) async {
        final DocumentSnapshot tenantRef =
            await _firestore.collection('users').doc(tenant['user_id']).get();

        if (!tenantRef.exists) {
          emit(RoomFailed(error: 'Tenant not found'));
          return;
        }
        final Map<String, dynamic> tenantData =
            tenantRef.data() as Map<String, dynamic>;
        tenants.add('${tenantData['first_name']} ${tenantData['last_name']}');
      });
      emit(RoomLoaded(tenants: tenants));
    } catch (e) {
      emit(RoomFailed(error: e.toString()));
    }
  }
}
