import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/models/user.dart' as model;

import '../utils/utils.dart';

class FollowingScreen extends StatefulWidget {
  static const String routeName = "Follower";
  final String uid;
  const FollowingScreen({Key? key, required this.uid}) : super(key: key);


  @override
  State<FollowingScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowingScreen> {
  var userData = {};
  List<model.User> followersList = [];
  List<model.User> followingList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;

      // Fetch follower user objects


      // Fetch following user objects
      for (String followingId in userSnap.data()!['following']) {
        var followingSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(followingId)
            .get();
        followingList.add(model.User.fromSnap(followingSnap));
      }
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : Scaffold(
      appBar: AppBar(
        title: Text("Following"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 2,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 2,),
          Expanded(
            child: ListView.builder(
              itemCount: followingList.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    followingList[index].photoUrl != ''
                        ? CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        followingList[index].photoUrl,
                      ),
                      radius: 40,
                    )
                        : const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 40,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(width: 20,),
                    Text(followingList[index].username)
                  ],
                );
              },

            ),
          ),
        ],
      ),
    );
  }
}
