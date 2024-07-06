import 'dart:convert';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../resources/auth_methods.dart';

part 'sign_up_screen_state.dart';

class SignUpScreenCubit extends Cubit<SignUpScreenState> {
  SignUpScreenCubit() : super(SignUpScreenInitial());

  Future<String> signup(String _usernameController, String _emailController,
      String _passwordController, String _bioController,
      Uint8List? selectedImageInBytes) async {
    emit(SignUpScreenLoading());
    try {
    String res =  await AuthMethods().signUpUser(
          email: _emailController,
          password: _passwordController,
          username: _usernameController,
          bio: _bioController,
          file: selectedImageInBytes!);
    if(res == 'success') {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://127.0.0.1:8000/api/auth/register'));
      request.fields.addAll({
        'ageRange': '18-25',
        'isDoctor': '0',
        'name': _usernameController,
        'gender': 'female',
        'rePassword': _passwordController,
        'password': _passwordController,
        'email': _emailController
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        var data = json.decode(await response.stream.bytesToString());
        String token = data['access_token'];
        String id = data['user']['id'].toString();
        pref.setString("id", id.toString());
        pref.setString("access_token", token);
        emit(SignUpScreenSuccess());
        return res;
      }
      else {
        emit(SignUpScreenError(
            response.reasonPhrase.toString()
        ));
        print(response.reasonPhrase);
        return response.reasonPhrase.toString();
      }
    }
    else{
      emit(SignUpScreenError(
          res
      ));
      return res;

    }
    } catch (ex) {
      print(ex.toString());
      emit(SignUpScreenError(
          ex.toString()
      ));
      print("Errror $ex");
      return ex.toString();
    }
  }
}
