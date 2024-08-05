part of 'tenant_bloc.dart';

@immutable
sealed class TenantEvent {
  @override
  List<Object> get props => [];
}

class ResetTenantState extends TenantEvent {
  ResetTenantState();
}

class GetTenants extends TenantEvent {
  final String propertyId;
  GetTenants({required this.propertyId});

  @override
  List<Object> get props => [propertyId];
}
