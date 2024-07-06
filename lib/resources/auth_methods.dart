import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone_flutter/models/user.dart' as model;
import 'package:instagram_clone_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User
  Future<String> signUpUser({
    required String email, required String password, required String username, required String bio, required Uint8List file,
  }) async {
    String authMessage = "Error Occurred, Please Try Again";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file != null) {
        // registering user using Firebase Authentication with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password,);
        // Save profile photo in Firebase FireStorage
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        // Creating user model instance
        model.User user = model.User(username: username, uid: cred.user!.uid, photoUrl: photoUrl, email: email, bio: bio, followers: [], following: [], phone: '',);
        await _firestore              // adding user in our Firebase FireStore Database
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        authMessage = "success";
      } else {
        authMessage = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return authMessage;
  }

  // logging in user
  Future<String> loginUser({required String email, required String password,
  }) async {
    String authMessage = "Error Signing In, Please Try Again";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password using Firebase Authentication
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        authMessage = "success";
      }
      else {
        authMessage = "Please Enter All Fields";
      }
    } catch (err) {
      return err.toString();
    }
    return authMessage;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
