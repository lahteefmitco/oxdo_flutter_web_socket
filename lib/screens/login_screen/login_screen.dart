import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxdo_web_socket/repositories/api_service.dart';
import 'package:oxdo_web_socket/screens/login_screen/cubit/login_cubit.dart';
import 'package:oxdo_web_socket/util/show_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(apiService: context.read<ApiService>()),
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (prev, cur) {
          return cur.maybeWhen(
              orElse: () => false, loginListenerState: (a, b) => true);
        },
        listener: (context, state) {
          state.mapOrNull(
            loginListenerState: (value) {
              final errorMessage = value.errorMessage;
              final route = value.route;

              if (errorMessage != null) {
                showSnackBar(context: context, message: errorMessage);
              }

              if (route != null) {
                Navigator.pushReplacementNamed(context, route);
              }
            },
          );
        },
        buildWhen: (prev, cur) {
          return cur.maybeWhen(
              orElse: () => false, loginBuldState: (a, b) => true);
        },
        builder: (context, state) {
          // to show error message
          String? errorMessage;

          // to show progressbar
          bool showProgressBar = false;

          state.mapOrNull(loginBuldState: (value) {
            errorMessage = value.showErrorMessage;
            showProgressBar = value.showProgressBar;
          });

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "LOGIN",
                            style: TextStyle(
                              color: Colors.blue[300],
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          // name field
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              label: Text("Name"),
                              labelStyle: TextStyle(color: Colors.black26),
                              floatingLabelStyle:
                                  TextStyle(color: Colors.black87),
                              hintText: "Enter Name",
                              hintStyle: TextStyle(color: Colors.black26),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter name";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          // userName field
                          TextFormField(
                            controller: _userNameController,
                            decoration: const InputDecoration(
                              label: Text("User Name"),
                              labelStyle: TextStyle(color: Colors.black26),
                              floatingLabelStyle:
                                  TextStyle(color: Colors.black87),
                              hintText: "Enter User Name",
                              hintStyle: TextStyle(color: Colors.black26),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter user name";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          // password field
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              label: Text("Password"),
                              labelStyle: TextStyle(color: Colors.black26),
                              floatingLabelStyle:
                                  TextStyle(color: Colors.black87),
                              hintText: "Enter password",
                              hintStyle: TextStyle(color: Colors.black26),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter password";
                              }
                              return null;
                            },
                          ),

                          // showing error message
                          errorMessage == null
                              ? const SizedBox()
                              : Text(
                                  errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),

                          const SizedBox(
                            height: 24,
                          ),

                          // login button
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // login
                                final name = _nameController.text.trim();
                                final userName =
                                    _userNameController.text.trim();
                                final password =
                                    _passwordController.text.trim();

                                context.read<LoginCubit>().login(
                                    userName: userName,
                                    password: password,
                                    name: name);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black87),
                            child: const Text("Login"),
                          )
                        ],
                      ),

                      // show progressbar
                      showProgressBar
                          ? const CircularProgressIndicator()
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
