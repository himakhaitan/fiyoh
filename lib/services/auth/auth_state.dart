part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User? user;

  AuthSuccess({required this.user});

  @override
  List<Object> get props => [user!];
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class AuthSignedOut extends AuthState {}

class AuthPasswordReset extends AuthState {}