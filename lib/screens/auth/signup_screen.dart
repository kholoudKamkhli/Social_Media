import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:instagram_clone_flutter/screens/auth/login_screen.dart';
import 'package:instagram_clone_flutter/screens/auth/sign_up_screen_content.dart';
import 'package:instagram_clone_flutter/utils/flash_bar.dart';

import '../../main.dart';
import '../../utils/dialog.dart';
import '../../viewModel/sign_up_screen_cubit.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpScreenCubit(),
      child: BlocListener<SignUpScreenCubit, SignUpScreenState>(
          listener: (context, state) {
            if (state is SignUpScreenSuccess) {
              Navigator.pop(context);
              showFlushBar("Success", context, Colors.green);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()),
                      (route) => false);
            }
            if (state is SignUpScreenError) {
              //show error message
              Navigator.pop(context);
              showFlushBar(state.message, context, Colors.red);
            }
            if (state is SignUpScreenLoading) {
              //show loading dialog
              dialogUtilites.lodingDialog(context, "Loading...");
            }
          },
          child: const SignUpScreenContent()),
    );
  }
}
