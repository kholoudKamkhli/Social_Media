import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/di/di.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/responsive/responsive_layout.dart';
import 'package:instagram_clone_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:instagram_clone_flutter/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;

  //Uint8List? _image;
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

  Future<void> signUpUser() async {
    // if photo is not selected, show error
    // if (selectedImageInBytes == null) {
    //   showSnackBar(context, 'Please select a photo');
    //   return;
    // }

    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    var authMethods = getIt<AuthMethods>();
    String res = await authMethods.signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: selectedImageInBytes ?? Uint8List(0), phone: '',
    );
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
            const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  // selectImage() async {
  //   Uint8List im = await pickImage(ImageSource.gallery);
  //   // set state because we need to display the image we selected on the circle avatar
  //   setState(() {
  //     _image = im;
  //   });
  // }
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Image.asset(
                'assets/glowyyy-removebg-preview.png',
                color: Color.fromRGBO(229, 184, 61, 1.0),
                height: 100,
              ),
              const SizedBox(
                height: 64,
              ),
              Stack(
                children: [
                  selectedImageInBytes != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(selectedImageInBytes!),
                  )
                      : const CircleAvatar(
                    backgroundImage: AssetImage('assets/l60Hf.png'),
                    radius: 64,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo,color: Color.fromRGBO(229, 184, 61, 1.0),),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () async {
                  await signUpUser();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: Color.fromRGBO(229, 184, 61, 1.0),
                  ),
                  child: !_isLoading
                      ? const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                    onTap: () =>
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Login.',
                        style: TextStyle(
                          color: Color.fromRGBO(229, 184, 61, 1.0),
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
    );
  }
}
