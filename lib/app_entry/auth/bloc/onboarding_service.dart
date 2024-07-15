import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentwise/constants/enums.dart';

class OnboardingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Creating User Document while SignUp
  Future<void> signupUserDocument(String uid, String email, String firstName,
      String lastName, String phoneNumber, String photoURL) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'email': email,
        'properties': [],
        'user_type': USER_TYPE.OWNER.value,
        'photo_url': photoURL,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Error Creating Signup User Data
      rethrow;
    }
  }

  // Get user data using uid
  Future<Object?> getUserData(String uid) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isNewUser(String uid) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(uid).get();
      return !docSnapshot.exists;
    } catch (e) {
      // Handle error as per your app's requirements
      rethrow;
    }
  }
}
