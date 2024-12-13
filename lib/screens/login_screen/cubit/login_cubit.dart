import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oxdo_web_socket/main.dart';
import 'package:oxdo_web_socket/repositories/api_service.dart';
import 'package:oxdo_web_socket/routes/route.dart';
import 'package:oxdo_web_socket/util/constants.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  final ApiService apiService;
  LoginCubit({required this.apiService}) : super(const LoginState.initial());

  void login({
    required String userName,
    required String password,
    required String name,
  }) async {
    try {
      // show progressbar
      emit(const LoginState.loginBuldState(showProgressBar: true));
      // login
      final String token =
          await apiService.login(userName: userName, password: password);

      // dismiss progressbar
      emit(const LoginState.loginBuldState(showProgressBar: false));

      // set token in shared preferences
      sharedPreferences.setString(token_key, token);

      // set name in shared preferences
      sharedPreferences.setString(name_key, name);

      

      // navigate to home screen
      emit(const LoginState.loginListenerState(route: homeScreen));
    } catch (e) {
      // show error message in ui and dismiss show progressbar
      emit( LoginState.loginBuldState(showProgressBar: false,showErrorMessage: e.toString()));
      // show snackbar
      emit(LoginState.loginListenerState(errorMessage: e.toString()));
    }
   
    
  }
}
