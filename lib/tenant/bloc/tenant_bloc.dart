import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tenant_event.dart';
part 'tenant_state.dart';

class TenantBloc extends Bloc<TenantEvent, TenantState> {
  TenantBloc() : super(TenantInitial()) {
    on<GetTenants>((event, emit) => _handleGetTenants(event, emit));
  }

  Future<void> _handleGetTenants(
      GetTenants event, Emitter<TenantState> emit) async {
        print("triggered");
    emit(TenantLoading());
    try {
      // Simulate a network request
      await Future.delayed(Duration(seconds: 1));
      emit(TenantLoaded(tenants: ["Tenant 1", "Tenant 2", "Tenant 3"]));
    } catch (e) {
      emit(TenantFailed(error: "Failed to load tenants"));
    }
  }
}
