part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  @override
  List<Object> get props => [];
}

// Initial state of the AuthBloc
class AuthInitial extends AuthState {}

// Loading state of the AuthBloc
class AuthLoading extends AuthState {}

// Success state of the AuthBloc
class AuthSuccess extends AuthState {
  final user_model.User user;

  AuthSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

// Failure state of the AuthBloc
class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// Signed out state of the AuthBloc
class AuthSignedOut extends AuthState {}

// Password reset state of the AuthBloc
class AuthPasswordReset extends AuthState {}