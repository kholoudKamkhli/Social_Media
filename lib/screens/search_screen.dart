import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone_flutter/screens/profile_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search for a user...',
                  border: InputBorder.none,
                ),
                onFieldSubmitted: (String _) {
                  setState(() {
                    isShowUsers = true;
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isShowUsers = true;
                });
              },
            ),
          ],
        ),
      ),
      body: isShowUsers
          ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
                    future: FirebaseFirestore.instance
              .collection('users')
              .where(
            'username',
            isGreaterThanOrEqualTo: searchController.text,
                    )
              .get(),
                    builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                var userDoc = (snapshot.data! as dynamic).docs[index];
                var userData = userDoc.data() as Map<String, dynamic>;
                var photoUrl = userData['photoUrl'] ?? ''; // Handle missing photoUrl

                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: userData['uid'],
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl)
                          : null,
                      radius: 16,
                      child: photoUrl.isEmpty ? Icon(Icons.person) : null,
                    ),
                    title: Text(
                      userData['username'],
                    ),
                  ),
                );
              },
            );
                    },
                  ),
          )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
                    future: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished')
              .get(),
                    builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return MasonryGridView.count(
              crossAxisCount: 3,
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                var postDoc = (snapshot.data! as dynamic).docs[index];
                var postData = postDoc.data() as Map<String, dynamic>;
                return Image.network(
                  postData['postUrl'],
                  fit: BoxFit.cover,
                );
              },
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            );
                    },
                  ),
          ),
    );
  }
}
