import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentwise/app_entry/auth/bloc/onboarding_service.dart';
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
    on<GoogleSignInEvent>((event, emit) => _handleGoogleSignIn(event, emit));
    on<GoogleSignUpEvent>((event, emit) => _handleGoogleSignUp(event, emit));
  }

  Future<void> _handleGoogleSignUp(
      GoogleSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(AuthFailure(error: "Google sign-up cancelled"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _onboardingService.signupUserDocument(
          user.uid,
          user.email ?? "",
          user.displayName ?? "",
          "", 
          user.phoneNumber ?? "",
          user.photoURL ?? "",
        );
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthFailure(error: "Google sign-up failed"));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _handleGoogleSignIn(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthFailure(error: "Google sign in failed"));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _handleSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
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
          "",
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

  Future<void> _handleSignOut(
      SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.signOut();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _handleResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: event.email);
      emit(AuthPasswordReset());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
