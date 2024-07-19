// Import Statements
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rentwise/constants/enums.dart';
import 'package:rentwise/models/user.dart' as user_model;

// Part Statements
part 'auth_event.dart';
part 'auth_state.dart';

// AuthBloc class that extends the Bloc class
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register event handlers in the constructor
  AuthBloc() : super(AuthInitial()) {
    // Handle SignUpEvent
    on<SignUpEvent>((event, emit) => _handleSignUp(event, emit));

    // Handle SignInEvent
    on<SignInEvent>((event, emit) => _handleSignIn(event, emit));

    // Handle SignOutEvent
    on<SignOutEvent>((event, emit) => _handleSignOut(event, emit));

    // Handle ResetPasswordEvent
    on<ResetPasswordEvent>((event, emit) => _handleResetPassword(event, emit));

    // Handle GoogleSignUpEvent
    on<GoogleSignUpEvent>((event, emit) => _handleGoogleSignUp(event, emit));

    // Handle GoogleSignInEvent
    on<GoogleSignInEvent>((event, emit) => _handleGoogleSignIn(event, emit));
  }

  // Handle SignUpEvent
  Future<void> _handleSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    // Emit AuthLoading state
    emit(AuthLoading());
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      // Get the user object
      User? user = userCredential.user;
      if (user != null) {
        // Creating User Object
        user_model.User newUser = user_model.User(
          id: user.uid,
          email: event.email,
          firstName: event.firstName,
          lastName: event.lastName,
          countryCode: "+91",
          phoneNumber: event.phoneNumber,
          userType: null,
          properties: [],
          profileUrl: "",
        );

        // Create user document in Firestore
        await signupUserDocument(newUser);

        // Emit AuthSuccess state
        emit(AuthSuccess(user: newUser));
      } else {
        // Emit AuthFailure state
        emit(AuthFailure(error: "Signup failed"));
      }
    } catch (e) {
      // Emit AuthFailure state
      emit(AuthFailure(error: e.toString()));
    }
  }

  // Handle SignInEvent
  Future<void> _handleSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    // Emit AuthLoading state
    emit(AuthLoading());
    try {
      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // Get the user object
      User? user = userCredential.user;

      // Check if user is not null
      if (user != null) {
        // Fetch user data from Firestore
        user_model.User? userData = await fetchUserData(user.uid);
        if (userData == null) {
          // Emit AuthFailure state
          emit(AuthFailure(error: "User data not found"));
          return;
        }
        // Emit AuthSuccess state
        emit(AuthSuccess(user: userData));
      } else {
        // Emit AuthFailure state
        emit(AuthFailure(error: "Sign in failed"));
      }
    } catch (e) {
      // Emit AuthFailure state
      emit(AuthFailure(error: e.toString()));
    }
  }

  // Handle SignOutEvent
  Future<void> _handleSignOut(
      SignOutEvent event, Emitter<AuthState> emit) async {
    // Emit AuthLoading state
    emit(AuthLoading());
    try {
      // Sign out the user
      await _auth.signOut();

      // Emit AuthSignedOut state
      emit(AuthSignedOut());
    } catch (e) {
      // Emit AuthFailure state
      emit(AuthFailure(error: e.toString()));
    }
  }

  // Handle ResetPasswordEvent
  Future<void> _handleResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    // Emit AuthLoading state
    emit(AuthLoading());
    try {
      // Send password reset email
      await _auth.sendPasswordResetEmail(email: event.email);

      // Emit AuthPasswordReset state
      emit(AuthPasswordReset());
    } catch (e) {
      // Emit AuthFailure state
      emit(AuthFailure(error: e.toString()));
    }
  }

  // Handle GoogleSignUpEvent
  Future<void> _handleGoogleSignUp(
      GoogleSignUpEvent event, Emitter<AuthState> emit) async {
    // Emit AuthLoading state
    emit(AuthLoading());
    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Check if googleUser is null
      if (googleUser == null) {
        emit(AuthFailure(error: "Google sign-up cancelled"));
        return;
      }

      // Get the authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Check if user is not null
      if (user != null) {
        List<String> names = user.displayName!.split(" ");
        String firstName = names[0];
        String lastName = names.sublist(1).join(" ");

        // Create User Object
        user_model.User newUser = user_model.User(
          id: user.uid,
          firstName: firstName,
          lastName: lastName,
          email: user.email ?? "",
          countryCode: "+91",
          phoneNumber: user.phoneNumber ?? "",
          userType: null,
          properties: [],
          profileUrl: user.photoURL ?? "",
        );

        // Create user document in Firestore
        await signupUserDocument(newUser);

        // Check if user is new
        emit(AuthSuccess(user: newUser));
      } else {
        // Emit AuthFailure state
        emit(AuthFailure(error: "Google sign-up failed"));
      }
    } catch (e) {
      // Emit AuthFailure state
      emit(AuthFailure(error: e.toString()));
    }
  }

  // Handle GoogleSignInEvent
  Future<void> _handleGoogleSignIn(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    // Emit AuthLoading state
    emit(AuthLoading());
    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Check if user is not null
      if (user != null) {
        bool isNewUserTag = await isNewUser(user.uid);
        if (isNewUserTag) {
          // User is new
          // Seperate display name into first name and last name
          List<String> names = user.displayName!.split(" ");
          String firstName = names[0];
          String lastName = names.sublist(1).join(" ");

          // Create User Object
          user_model.User newUser = user_model.User(
            id: user.uid,
            firstName: firstName,
            lastName: lastName,
            email: user.email ?? "",
            countryCode: "+91",
            phoneNumber: user.phoneNumber ?? "",
            userType: null,
            properties: [],
            profileUrl: user.photoURL ?? "",
          );

          // Create user document in Firestore
          await signupUserDocument(newUser);

          // Emit AuthSuccess state
          emit(AuthSuccess(user: newUser));
        } else {
          // User is not new
          // Fetch user data from Firestore
          user_model.User? userData = await fetchUserData(user.uid);

          // Check if user data is not null
          if (userData == null) {
            // Emit AuthFailure state
            emit(AuthFailure(error: "User data not found"));
            return;
          }
          // Emit AuthSuccess state
          emit(AuthSuccess(user: userData));
        }
      } else {
        // User is null
        emit(AuthFailure(error: "Google sign in failed"));
      }
    } catch (e) {
      // An error occurred
      emit(AuthFailure(error: e.toString()));
    }
  }

  // Function to post user data to Firestore
  Future<void> signupUserDocument(user_model.User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
        'country_code': user.countryCode,
        'phone_number': user.phoneNumber,
        'user_type': UserType.owner.value,
        'photo_url': user.profileUrl,
        'properties': [],
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Error Creating Signup User Data
      rethrow;
    }
  }

  // Function to fetch user data from firestore
  Future<user_model.User?> fetchUserData(String uid) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(uid).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Return the user object
        return user_model.User.fromDocumentSnapshot(docSnapshot);
      } else {
        // Return null if the document does not exist
        return null;
      }
    } catch (e) {
      // Error fetching user data
      rethrow;
    }
  }

  // Function to check if user is new
  Future<bool> isNewUser(String uid) async {
    try {
      // Get user data
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(uid).get();

      // Return true if user does not exist
      return !docSnapshot.exists;
    } catch (e) {
      // Handle error as per your app's requirements
      rethrow;
    }
  }
}