import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/screens/chat/screens/home_screen.dart';
import 'package:instagram_clone_flutter/screens/shop.dart';
import 'package:instagram_clone_flutter/screens/skin_test.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();

    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }
  List<Widget> homeScreenItems = [
    const FeedScreen(),
    const SearchScreen(),
    const AddPostScreen(),
    ProfileScreen(
      uid:FirebaseAuth.instance.currentUser!.uid,
    ),
    const HomeChat(),
    const SkinTest(),
    const ShopScreen()
  ];
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        //leading: SizedBox(width: 0,),
        centerTitle: false,
        title:  Row(
          children: [
            Image.asset(
              "assets/logo_final-removebg-preview.png",
              height: 80,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              size: 35,
              Icons.home,
              color: _page == 0 ? const Color.fromARGB(255, 40, 167, 69)
              : secondaryColor,
            ),
            onPressed: () => navigationTapped(0),
          ),
          IconButton(
            icon: Icon(
              size: 35,
              Icons.search,
              color: _page == 1 ? const  Color.fromARGB(255, 40, 167, 69) : secondaryColor,
            ),
            onPressed: () => navigationTapped(1),
          ),
          IconButton(
            icon: ImageIcon(
              size: 40,
              AssetImage("assets/2763259.png"),
              color: _page == 5 ? const Color.fromARGB(255, 40, 167, 69): secondaryColor,
            ),
            onPressed: () => navigationTapped(5),
          ),
          IconButton(
            icon: ImageIcon(
              size: 40,
              AssetImage("assets/3482672-200.png")
              ,color: _page == 6 ? const Color.fromARGB(255, 40, 167, 69) : secondaryColor,
            ),
            onPressed: () => navigationTapped(6),
          ),
          IconButton(
            icon: Icon(
              size: 35,
              Icons.add_a_photo,
              color: _page == 2 ? const  Color.fromARGB(255, 40, 167, 69) : secondaryColor,
            ),
            onPressed: () => navigationTapped(2),
          ),
          IconButton(
            icon: Icon(
              size: 35,
              Icons.chat,
              color: _page == 4 ? const  Color.fromARGB(255, 40, 167, 69) : secondaryColor,
            ),
            onPressed: () => navigationTapped(4),
          ),
          IconButton(
            icon: Icon(
              size: 35,
              Icons.person,
              color: _page == 3 ? const  Color.fromARGB(255, 40, 167, 69) : secondaryColor,
            ),
            onPressed: () => navigationTapped(3),
          ),


        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
    );
  }
  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),webOnlyWindowName: "_self")) {
      throw Exception('Could not launch ');
    }
  }
}
