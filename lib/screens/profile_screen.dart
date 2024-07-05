import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/screens/chat/models/chat_user.dart';
import 'package:instagram_clone_flutter/screens/chat/screens/chat_screen.dart';
import 'package:instagram_clone_flutter/screens/followers_screen.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:instagram_clone_flutter/widgets/follow_button.dart';
import 'package:instagram_clone_flutter/models/user.dart' as model;

import '../models/user.dart';
import 'chat/api/apis.dart';
import 'chat/helper/dialogs.dart';
import 'chat/screens/home_screen.dart';
import 'following_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  List<model.User> followersList = [];
  List<model.User> followingList = [];
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
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
          .where('uid', isEqualTo: userSnap.data()!['uid'])
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;

      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
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
    print("the user id is ${widget.uid}");
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          userData['photoUrl'] != ''
                              ? CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                    userData['photoUrl'],
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
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "posts"),
                                    InkWell(
                                        onTap: () {

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FollowersScreen(
                                                        uid: widget.uid,
                                                      )));
                                        },
                                        child: buildStatColumn(
                                            followers, "followers")),
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FollowingScreen(
                                                        uid: widget.uid,
                                                      )));
                                        },
                                        child: buildStatColumn(
                                            following, "following")),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Sign Out',
                                            backgroundColor: const Color.fromRGBO(
                                                229, 184, 61, 1.0),
                                            textColor: Colors.white,
                                            borderColor: const Color.fromRGBO(
                                                229, 184, 61, 1.0),
                                            function: () async {
                                              await AuthMethods().signOut();
                                              if (context.mounted) {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen(),
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        : Row(
                                            children: [
                                              isFollowing
                                                  ? FollowButton(
                                                      text: 'Unfollow',
                                                      backgroundColor:
                                                          Colors.white,
                                                      textColor: Colors.black,
                                                      borderColor:
                                                          const Color.fromRGBO(229,
                                                              184, 61, 1.0),
                                                      function: () async {
                                                        await FireStoreMethods()
                                                            .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid'],
                                                        );

                                                        setState(() {
                                                          isFollowing = false;
                                                          followers--;
                                                        });
                                                      },
                                                    )
                                                  : FollowButton(
                                                      text: 'Follow',
                                                      backgroundColor:
                                                          const Color.fromRGBO(229,
                                                              184, 61, 1.0),
                                                      textColor: Colors.white,
                                                      borderColor:
                                                          const Color.fromRGBO(229,
                                                              184, 61, 1.0),
                                                      function: () async {
                                                        await FireStoreMethods()
                                                            .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid'],
                                                        );

                                                        setState(() {
                                                          isFollowing = true;
                                                          followers++;
                                                        });
                                                      },
                                                    ),
                                              FollowButton(
                                                  function: () async {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       builder: (context) =>
                                                    //           ChatScreen(
                                                    //             userId1: FirebaseAuth
                                                    //                 .instance
                                                    //                 .currentUser!
                                                    //                 .uid,
                                                    //             userId2:
                                                    //                 widget.uid,
                                                    //           )),
                                                    // );
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //         const HomeChat()));
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) => ChatScreen(user:ChatUser(image: userData['photoUrl'], about: userData['bio'], name:userData['username'] , createdAt: userData["created_at"], isOnline: userData["is_online"], id: userData["id"], lastActive: userData["last_active"], email: userData["email"], pushToken:userData["push_token"] ) )));
                                                    await APIs.addChatUser(userData['email'])
                                                        .then((value) {
                                                      if (!value) {
                                                        Dialogs.showSnackbar(
                                                            context, 'User does not Exists!');
                                                      }
                                                    });
                                                  },
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          229, 184, 61, 1.0),
                                                  borderColor: const Color.fromRGBO(
                                                      229, 184, 61, 1.0),
                                                  text: userData['type'] == "doctor"?"Consult":"Message",
                                                  textColor: Colors.white),
                                            ],
                                          )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['type'] == "doctor"?"${userData['username']} (Doctor)":userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return SizedBox(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
