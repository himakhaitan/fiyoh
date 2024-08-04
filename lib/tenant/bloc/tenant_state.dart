part of 'tenant_bloc.dart';

@immutable
sealed class TenantState {}

final class TenantInitial extends TenantState {
  @override
  List<Object> get props => [];
}

final class TenantLoading extends TenantState {
  @override
  List<Object> get props => [];
}

final class TenantFailed extends TenantState {
  final String error;

  TenantFailed({required this.error});

  @override
  List<Object> get props => [error];
}

final class TenantLoaded extends TenantState {
  final List<Tenant> tenants;
  final String propertyId;

  TenantLoaded({required this.tenants, required this.propertyId});

  @override
  List<Object> get props => [tenants, propertyId];
}
