import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone_flutter/models/user.dart' as model;
import 'package:instagram_clone_flutter/resources/storage_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
@singleton
class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  model.User? user;
  SharedPreferences? prefs;
bool is_auth=false;
  Future<void> saveuser(model.User user) async {
    prefs = await SharedPreferences.getInstance();
    prefs?.setString('id', user.uid);
    prefs?.setString('name', user.username);
    prefs?.setString('email', user.email);
    prefs?.setString('photo', user.photoUrl ?? '');
    prefs?.setBool('auth', true);
    is_auth = true;
  }

  // Notifies listeners of state changes
  // Asynchronously deletes user information from local storage
  Future<void> deleteuser() async {
    prefs = await SharedPreferences.getInstance();
    prefs?.remove('id');
    prefs?.remove('name');
    prefs?.remove('email');
    prefs?.remove('photo');
    prefs?.remove('auth');
     user = null;
    is_auth = false;
  }

  // Asynchronously retrieves user information from local storage
  Future<void> getuser() async {
    prefs = await SharedPreferences.getInstance();
    is_auth = prefs?.getBool('auth') ?? false;
    if(is_auth){
      String id = prefs?.getString('id') ?? '';
      user= await getUserDetails(id);
    }
    // If user ID is found, create a new UserLocal object and set is_auth to true
  }

  // get user details
  Future<model.User> getUserDetails(String id) async {

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(id).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl =
            await StorageMethods().uploadImageToStorage('profilePics', file, false);

         user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );
      await  saveuser(user!);
        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user!.toJson());
        print("dada 3ml sign up");
        print(user!.username);
        print(user!.email);
        print(user!.uid);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // logging in user with email and password
    var cred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
         user=await getUserDetails(cred.user!.uid);
         print(user!.username);
         print(user!.email);
          print(user!.uid);
        await saveuser(user!);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await deleteuser();

  }
  Future<List<Map<String, dynamic>>> get_post_of_users_in_following() async {
    List<Map<String, dynamic>> posts = [];
    var userDoc = await _firestore.collection('users').doc(user!.uid).get();
    var followingList = userDoc.data()?['following'] ?? [];

    for (var userId in followingList) {
      var userPosts = await _firestore.collection('posts').where('uid', isEqualTo: userId).get();
      for (var post in userPosts.docs) {
        posts.add(post.data());
      }
    }
    return posts;
  }}
