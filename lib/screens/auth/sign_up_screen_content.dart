import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/responsive/responsive_layout.dart';
import 'package:instagram_clone_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/screens/auth/login_screen.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../../utils/flash_bar.dart';
import '../../viewModel/sign_up_screen_cubit.dart';

class SignUpScreenContent extends StatefulWidget {
  const SignUpScreenContent({super.key});

  @override
  State<SignUpScreenContent> createState() => _SignUpScreenContentState();
}

class _SignUpScreenContentState extends State<SignUpScreenContent> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String selctFile = '';
  XFile? file;
  Uint8List? selectedImageInBytes;
  List<Uint8List> pickedImagesInBytes = [];
  List<String> imageUrls = [];
  int imageCounts = 0;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  selectImage() async {
    FilePickerResult? fileResult =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (fileResult != null) {
      setState(() {
        selctFile = fileResult.files.first.name;
        selectedImageInBytes = fileResult.files.first.bytes;
      });

      fileResult.files.forEach((element) {
        setState(() {
          pickedImagesInBytes.add(element.bytes!);
          imageCounts += 1;
        });
      });
    }
    print(selctFile);
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<SignUpScreenCubit>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
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
                const SizedBox(
                  height: 14,
                ),
                Stack(
                  children: [
                    selectedImageInBytes != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(selectedImageInBytes!),
                            backgroundColor: Colors.grey,
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: AssetImage(
                                "assets/pictureeee-removebg-preview.png"),
                            backgroundColor: Color.fromARGB(12, 255, 255, 240),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        color: Colors.grey,
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration:
                      const InputDecoration(hintText: 'Enter your username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
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
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(hintText: 'Enter your bio'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your bio';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: () async {
                    // check if the photo is not selected
                    if (selectedImageInBytes == null) {
                      showFlushBar( 'Please select a photo',context, Colors.red);
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      await cubit.signup(
                        _usernameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _bioController.text,
                        selectedImageInBytes,
                      );
                    }

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
                            'Sign up',
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
                        'Already have an account?',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Login.',
                          style: TextStyle(
                            color: Color.fromARGB(255, 40, 167, 69),
                            fontWeight: FontWeight.bold,
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
