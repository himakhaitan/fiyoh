part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  SignUpEvent(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber});

  @override
  List<Object> get props => [email, password, firstName, lastName, phoneNumber];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignOutEvent extends AuthEvent {}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  ResetPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class GoogleSignInEvent extends AuthEvent {
  GoogleSignInEvent();

  @override
  List<Object> get props => [];
}

class GoogleSignUpEvent extends AuthEvent {
  GoogleSignUpEvent();

  @override
  List<Object> get props => [];
}

class CheckUserTypeEvent extends AuthEvent {
  final String userType;

  CheckUserTypeEvent({required this.userType});

  @override
  List<Object> get props => [userType];
}