import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oxdo_web_socket/repositories/api_service.dart';
import 'package:oxdo_web_socket/main.dart';
import 'package:oxdo_web_socket/routes/route.dart';
import 'package:oxdo_web_socket/util/constants.dart';

part 'splash_state.dart';
part 'splash_cubit.freezed.dart';

class SplashCubit extends Cubit<SplashState> {
  final ApiService apiService;
  SplashCubit({required this.apiService}) : super(const SplashState.initial()) {
    // Calling  _getWelcomeMessage function when initializing ths cubit
    _getWelcomeMessage();
  }

  // get welcome message  from the repository
  Future<void> _getWelcomeMessage() async {
    try {
      // show progressbar
      emit(const SplashState.splashScreenBuildStates(showProgressBar: true));

      // get welcome message
      final welcomeMessage = await apiService.getWelcomeMessage();

      // dismiss  progressbar and show welcome message
      emit(SplashState.splashScreenBuildStates(
          showProgressBar: false, welcomeMessage: welcomeMessage));

      // giving delay of 3 seconds before navigating to next screen
      await Future.delayed(const Duration(seconds: 3));

      // get token from the shared preferences
      final token = sharedPreferences.getString(token_key);

      if (token == null || token.isEmpty) {
        // if token is null, navigate to login screen
        emit(const SplashState.splashScreenListenerStates(route: loginScreen));
      } else {
        // if token is not null, navigate to home screen
        emit(const SplashState.splashScreenListenerStates(route: homeScreen));
      }
    } catch (e) {
      log(e.toString(), name: "oxdo");
      // dismiss  progressbar
      emit(const SplashState.splashScreenBuildStates(showProgressBar: false));
      // show snackbar
      emit(SplashState.splashScreenListenerStates(errorMessage: e.toString()));
    }
  }
}
