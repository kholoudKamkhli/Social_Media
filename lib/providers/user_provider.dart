import 'package:flutter/widgets.dart';
import 'package:instagram_clone_flutter/di/di.dart';
import 'package:instagram_clone_flutter/models/user.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = getIt<AuthMethods>();

  User get getUser => _user?? const User(username: '', uid: '', email: '', photoUrl: '', bio: '', followers: [], following: [], phone: '');

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails(
      _authMethods.user!.uid,
    );
    _user = user;
    notifyListeners();
  }
}