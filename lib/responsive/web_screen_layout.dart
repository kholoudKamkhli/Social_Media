import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone_flutter/screens/chat/screens/home_screen.dart';
import 'package:instagram_clone_flutter/screens/followers_screen.dart';
import 'package:instagram_clone_flutter/screens/following_screen.dart';
import 'package:instagram_clone_flutter/screens/shop.dart';
import 'package:instagram_clone_flutter/screens/skin_test.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../di/di.dart';
import '../main.dart';
import '../resources/auth_methods.dart';
import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import 'dart:js' as js;

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
        centerTitle: false,
        title: Image.asset(
          'assets/glowyyy-removebg-preview.png',
          height: 80,
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(
          //     Icons.store,
          //     color: secondaryColor,
          //   ),
          //   onPressed: (){
          //     // js.context.callMethod('open', ["http://127.0.0.1:3000/home/${pref.getString("access_token")}/${pref.getString("id")}"]);
          //      _launchUrl("http://127.0.0.1:3000/shop/${pref.getString("access_token")}/${pref.getString("id")}",);
          //   },
          // ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.face,
          //     color: secondaryColor,
          //   ),
          //   onPressed: (){
          //     // js.context.callMethod('open', ["http://127.0.0.1:3000/home/${pref.getString("access_token")}/${pref.getString("id")}"]);
          //     _launchUrl("http://127.0.0.1:3000/skintest/${pref.getString("access_token")}/${pref.getString("id")}",);
          //   },
          // ),
          IconButton(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? const Color.fromRGBO(229, 184, 61, 1.0) : secondaryColor,
            ),
            onPressed: () => navigationTapped(0),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? const Color.fromRGBO(229, 184, 61, 1.0) : secondaryColor,
            ),
            onPressed: () => navigationTapped(1),
          ),
          IconButton(
            icon: Icon(
              Icons.add_a_photo,
              color: _page == 2 ? const Color.fromRGBO(229, 184, 61, 1.0) : secondaryColor,
            ),
            onPressed: () => navigationTapped(2),
          ),

          IconButton(
            icon: Icon(
              Icons.person,
              color: _page == 3 ? const Color.fromRGBO(229, 184, 61, 1.0) : secondaryColor,
            ),
            onPressed: () => navigationTapped(3),
          ),
          IconButton(
            icon: Icon(
              Icons.chat,
              color: _page == 4 ? const Color.fromRGBO(229, 184, 61, 1.0) : secondaryColor,
            ),
            onPressed: () => navigationTapped(4),
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: _page == 5 ? const Color.fromRGBO(229, 184, 61, 1.0) : secondaryColor,
            ),
            onPressed: () => navigationTapped(5),
          ),
          IconButton(
            icon: Icon(
              Icons.store,
              color: _page == 6 ? const Color.fromRGBO(229, 184, 61, 1.0) : secondaryColor,
            ),
            onPressed: () => navigationTapped(6),
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
