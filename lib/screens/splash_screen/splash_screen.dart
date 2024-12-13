import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxdo_web_socket/repositories/api_service.dart';
import 'package:oxdo_web_socket/screens/splash_screen/cubit/splash_cubit.dart';
import 'package:oxdo_web_socket/util/show_snackbar.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String welcomeMessage = "";
    bool showProgressBar = false;
    return BlocProvider(
      create: (context) => SplashCubit(apiService: context.read<ApiService>()),
      child: BlocConsumer<SplashCubit, SplashState>(
        listenWhen: (prev, cur) {
          return cur.maybeWhen(
            orElse: () => false,
            // listen only for splashScreenListenerStates
            splashScreenListenerStates: (a, b) => true,
          );
        },
        listener: (context, state) {
          state.mapOrNull(splashScreenListenerStates: (value) {
            final errorMessage = value.errorMessage;

            if (errorMessage != null) {
              // if error message is not null, show snackbar
              showSnackBar(context: context, message: errorMessage);
            }

            final String? route = value.route;
            if (route != null) {
              // if route is not null, navigate the next screen
              Navigator.pushReplacementNamed(context, route);
            }
          });
        },
        buildWhen: (prev, cur) {
          return cur.maybeWhen(
            orElse: () => false,
            // build only for splashScreenBuildStates
            splashScreenBuildStates: (a, b) => true,
          );
        },
        builder: (context, state) {
          state.mapOrNull(splashScreenBuildStates: (value) {
            welcomeMessage = value.welcomeMessage ?? "";
            showProgressBar = value.showProgressBar;
          });
          return Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(welcomeMessage),
                ),
                showProgressBar
                    ? const CircularProgressIndicator()
                    : const SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }
}
