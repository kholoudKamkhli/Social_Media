import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/responsive/responsive_layout.dart';
import 'package:instagram_clone_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

late Size mq;
late SharedPreferences pref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   pref = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Glowified Skin',
          theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home:FirebaseAuth.instance.currentUser !=null? const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ):const LoginScreen()
      ),
    );
  }
}
