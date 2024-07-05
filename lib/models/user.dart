import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String phone;
  final String bio;
  final List followers;
  final List following;

  const User(
      {required this.username,
        required this.uid,
        required this.photoUrl,
        required this.email,
        required this.bio,
        required this.followers,
        required this.following,
        required this.phone});

  static User fromSnap(DocumentSnapshot snap) {
    print('snap : ${snap.data()}');
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        username: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        photoUrl: snapshot["photoUrl"],
        bio: snapshot["bio"],
        followers: snapshot["followers"],
        following: snapshot["following"],
        phone: snapshot["phone"]);
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "email": email,
    "photoUrl": photoUrl,
    "bio": bio,
    'isAccept': true,
    "followers": followers,
    "following": following,
    "phone": phone,
    "push_token": '',
    'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
    'is_online': false,
    'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
    'id': uid,
    'blocked': [],
    'spam': false,
    'blockedByUsers': [],
    'usersBlocked': [],
    'type':'user',
    'services': [],
    'groups': [],
    'groups_posts': []
  };
}
