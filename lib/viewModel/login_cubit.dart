import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../resources/auth_methods.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import 'dart:convert';
part 'login_state.dart';
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<String> login(String email, String password) async {
    emit(LoginLoading());
    try {
      String res = await AuthMethods().loginUser(
          email: email, password: password);
      if (res == 'success') {
        var request = http.MultipartRequest(
            'POST', Uri.parse('http://127.0.0.1:8000/api/auth/login'));
        request.fields.addAll({
          'password': password,
          'email': email,
        });
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var data = json.decode(await response.stream.bytesToString());
          String token = data['access_token'];
          String id = data['user']['id'].toString();
          pref.setString("id", id.toString());
          pref.setString("access_token", token);
          emit(LoginSuccess());
          return res;
        } else {
          return response.reasonPhrase.toString();
        }
      }
      else{
        emit(LoginError(
            res
        ));
        return res;
      }
    }
    catch (e) {
      emit(LoginError(
          e.toString()
      ));
      return e.toString();
    }
  }
}
