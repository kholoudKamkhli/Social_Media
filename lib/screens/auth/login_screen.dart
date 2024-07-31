import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/responsive/responsive_layout.dart';
import 'package:instagram_clone_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/screens/auth/login_screen_content.dart';
import 'package:instagram_clone_flutter/screens/auth/signup_screen.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_clone_flutter/viewModel/login_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../utils/dialog.dart';
import '../../utils/flash_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => LoginCubit(),
  child: BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  )),
              (route) => false);
          showFlushBar("Login Successfully", context, Colors.green);
        }
        if (state is LoginError) {
          //show error message
          Navigator.pop(context);
          showFlushBar(state.message, context, Colors.red);
        }
        if(state is LoginLoading){
          //show loading dialog
          showFlushBar("Loading...", context, Colors.grey);
        }
      },
  child: const LoginScreenContent(),
),
);
  }


}
