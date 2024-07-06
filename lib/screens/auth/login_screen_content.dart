import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_flutter/screens/auth/signup_screen.dart';
import 'dart:convert';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/responsive/responsive_layout.dart';
import 'package:instagram_clone_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../../viewModel/login_cubit.dart';

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({super.key});

  @override
  State<LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<LoginScreenContent> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<LoginCubit>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                Image.asset(
                  "assets/pictureeee-removebg-preview.png",
                  height: 380,
                ),
                const SizedBox(
                  height: 64,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration:
                      const InputDecoration(hintText: 'Enter your email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration:
                      const InputDecoration(hintText: 'Enter your password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: () async {
                    if(!_formKey.currentState!.validate()) return;
                    await cubit.login(_emailController.text,
                        _passwordController.text);
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      color: Color.fromARGB(255, 40, 167, 69),
                    ),
                    child: !_isLoading
                        ? const Text(
                            'Log in',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Don\'t have an account?',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Signup.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 40, 167, 69),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
