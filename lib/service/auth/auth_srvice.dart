import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socially/model/userModel.dart';
import 'package:socially/service/exceptions/exceptions.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      // Obtain the GoogleSignInAuthentication object
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google Auth credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Prepare user data
        final UserModel newuser = UserModel(
          userId: user.uid,
          name: user.displayName ?? "No name",
          email: user.email ?? "No email",
          jobTitle: "jobTitle",
          imageUrl: user.photoURL ?? "",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          password: "",
          followers: 0,
        );

        // Save user to Firestore
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userDocRef.set(newuser.toJson());
      }
    } on FirebaseAuthException catch (e) {
      print(
          'Error signing in with Google: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Error signing in: ${mapFirebaseAuthExceptionCode(e.code)}');

      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error creating user: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error creating user: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw Exception(mapFirebaseAuthExceptionCode(error.code));
    } catch (error) {
      print(error);
    }
  }
}
