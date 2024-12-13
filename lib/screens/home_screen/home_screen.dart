import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxdo_web_socket/main.dart';
import 'package:oxdo_web_socket/routes/route.dart';
import 'package:oxdo_web_socket/screens/home_screen/cubit/home_cubit.dart';
import 'package:oxdo_web_socket/util/constants.dart';
import 'package:oxdo_web_socket/util/show_alert_dialog.dart';
import 'package:oxdo_web_socket/util/show_snackbar.dart';
import 'package:oxdo_web_socket/util/time_formatter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();

  final nameInSystem = sharedPreferences.getString(name_key);

  @override
  void dispose() {
    _messageController.dispose();

    super.dispose();
  }

  void _scrollToLastItem() {
    // Scroll to the last position
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (prev, cur) {
          return cur.maybeWhen(
            orElse: () => false,
            homeListenerState: (errorMessage, route, showDialog) => true,
          );
        },
        listener: (context, state) {
          state.mapOrNull(homeListenerState: (value) {
            final errorMessage = value.errorMessage;
            if (errorMessage != null) {
              showSnackBar(context: context, message: errorMessage);
            }
            final route = value.route;
            if (route != null) {
              Navigator.of(context).popAndPushNamed(route);
            }
            final showDialog = value.showDialogWithString;
            if (showDialog != null) {
              showAlertDialog(
                  context: context,
                  message: showDialog,
                  callback: () {
                    log("call back ${Navigator.canPop(context)}");
                    sharedPreferences.setString(name_key, "");
                    sharedPreferences.setString(token_key, "");
                    Navigator.of(context).popAndPushNamed(loginScreen);
                  },
                  listenClickOutside: () {
                    log("called listener ${Navigator.canPop(context)}");
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      sharedPreferences.setString(name_key, "");
                      sharedPreferences.setString(token_key, "");
                      Navigator.of(context).popAndPushNamed(loginScreen);
                    });
                    // if(Navigator.canPop(context)){

                    // }
                  });
            }
          });
        },
        buildWhen: (prev, cur) {
          return cur.maybeWhen(
            orElse: () => false,
            homeBuildState: (messages) => true,
          );
        },
        builder: (BuildContext context, HomeState state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _messageController.clear();
            _scrollToLastItem();
          });

          List<Map<String, dynamic>> messageList = [];
          state.mapOrNull(homeBuildState: (value) {
            messageList = value.messages;
          });

          return Scaffold(
            appBar: AppBar(
              title: const Text("OXDO WEB SOCKET"),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<HomeCubit>().logout();
                  },
                  icon: const Icon(Icons.login_outlined),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child:
                    // BlocBuilder<HomeCubit, HomeState>(
                    //   buildWhen: (prev, cur) {
                    //     return cur.maybeWhen(
                    //         orElse: () => false, homeBuildState: (messages) => true);
                    //   },
                    //   builder: (context, state) {
                    //     WidgetsBinding.instance.addPostFrameCallback((_) {
                    //       _messageController.clear();
                    //       _scrollToLastItem();
                    //     });

                    //     List<Map<String, dynamic>> messageList = [];
                    //     state.mapOrNull(homeBuildState: (value) {
                    //       messageList = value.messages;
                    //     });
                    //     return
                    Column(
                  children: [
                    Expanded(
                        child: ListView.separated(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        final messageMap = messageList[index];
                        final String nameFromRemote = messageMap["name"];
                        final String message = messageMap["message"];
                        final String dateTimeString = messageMap["dateTime"];

                        log("Date time $dateTimeString");

                        final DateTime dateTime =
                            DateTime.tryParse(dateTimeString)?.toLocal() ??
                                DateTime.now().toLocal();

                        final time = formatTime(dateTime);

                        if (nameFromRemote == nameInSystem) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ConstrainedBox(
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.90),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          time,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          nameFromRemote,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          message,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: width * 0.8),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        time,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      Text(
                                        nameFromRemote,
                                        style: const TextStyle(
                                            color: Colors.amber, fontSize: 15),
                                      ),
                                      Text(message)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 8,
                        );
                      },
                      itemCount: messageList.length,
                    )),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Enter Message here",
                        hintStyle: const TextStyle(color: Colors.black38),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<HomeCubit>().sendMessage(
                                    _messageController.text.trim(),
                                  );
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Message is Empty";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                //},
                //),
              ),
            ),
          );
        },
      ),
    );
  }
}
