
import 'package:instagram_clone_flutter/models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowingScreen extends StatefulWidget {
  final String uid;
  const FollowingScreen({required this.uid, Key? key}) : super(key: key);

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  List<model.User> following = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFollowers();
  }

  void fetchFollowers() async {
    following = await getFollowers(widget.uid);
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
        title: Text("Followers"),
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
              itemCount: following.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    following[index].photoUrl != ''
                        ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                                                width: 40,
                            height: 40
                            ,child: CircleAvatar(

                                                  backgroundColor: Colors.grey,
                                                  backgroundImage: NetworkImage(

                            following[index].photoUrl,
                                                  ),
                                                  radius: 50,
                                                ),
                          ),
                        )
                        : SizedBox(
                      height: 40,
                          width: 40
                          ,child: const CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                radius: 50,
                                                child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                                                ),
                                              ),
                        ),
                    SizedBox(width: 20,),
                    Text(following[index].username)
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
Future<List<model.User>> getFollowers(String userId) async {
  List<model.User> followers = [];
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      List<String> followerIds = List<String>.from(data['following']);

      for (String followerId in followerIds) {
        DocumentSnapshot followerDoc = await FirebaseFirestore.instance.collection('users').doc(followerId).get();
        if (followerDoc.exists) {
          followers.add(model.User.fromSnap(followerDoc));
        }
      }
    }
  } catch (e) {
    print("Error fetching following: $e");
  }
  return followers;
}
