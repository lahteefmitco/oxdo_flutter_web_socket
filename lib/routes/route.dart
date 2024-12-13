import 'package:oxdo_web_socket/screens/home_screen/home_screen.dart';
import 'package:oxdo_web_socket/screens/login_screen/login_screen.dart';
import 'package:oxdo_web_socket/screens/splash_screen/splash_screen.dart';

const String splashScreen = "/splash";
const String loginScreen = "/login";
const String homeScreen = "/home";

final routes = {
  "/": (context) => const SplashScreen(),
  "/login": (context) => const LoginScreen(),
  "/home": (context) => const HomeScreen()
};
