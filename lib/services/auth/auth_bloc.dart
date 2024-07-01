import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentwise/services/auth/onboarding_service.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final OnboardingService _onboardingService = OnboardingService();

  AuthBloc() : super(AuthInitial()) {
    // Register event handlers in the constructor
    on<SignUpEvent>((event, emit) => _handleSignUp(event, emit));
    on<SignInEvent>((event, emit) => _handleSignIn(event, emit));
    on<SignOutEvent>((event, emit) => _handleSignOut(event, emit));
    on<ResetPasswordEvent>((event, emit) => _handleResetPassword(event, emit));
  }

  Future<void> _handleSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _onboardingService.signupUserDocument(
          user.uid,
          event.email,
          event.firstName,
          event.lastName,
          event.phoneNumber,
        );
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthFailure(error: "Signup failed"));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _handleSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      User? user = userCredential.user;
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthFailure(error: "Sign in failed"));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _handleSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.signOut();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _handleResetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: event.email);
      emit(AuthPasswordReset());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}