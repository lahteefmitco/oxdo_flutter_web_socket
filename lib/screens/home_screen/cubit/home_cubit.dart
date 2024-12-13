import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oxdo_web_socket/main.dart';
import 'package:oxdo_web_socket/routes/route.dart';
import 'package:oxdo_web_socket/util/constants.dart';
import 'package:web_socket_channel/io.dart';

part 'home_state.dart';

part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  // intitlaize web socket channel
  final IOWebSocketChannel webSocketChannel = IOWebSocketChannel.connect(
    Uri.parse(web_socket_url), // server web socket url
    headers: {
      'authorization':
          'Bearer ${sharedPreferences.getString(token_key)}', // Authorization token
      'name': sharedPreferences.getString(name_key), // name
      // Custom headers
    },
  );

  StreamSubscription? _streamSubscription;

  final List<Map<String, dynamic>> receiveMessageMapList = [];

  HomeCubit() : super(const HomeState.initial()) {
    try {
      // Receiving messages from the web socket in constructor
      _streamSubscription = webSocketChannel.stream.listen(
        (data) {
          final String receivedJson = data;

          log(receivedJson);

          // converting received message to map
          final receivedMap = jsonDecode(receivedJson);

          // add to a list
          receiveMessageMapList.add(receivedMap);

          log(receiveMessageMapList.toString());

          emit(const HomeState.initial());

          // emiting messages as map list
          emit(HomeState.homeBuildState(messages: receiveMessageMapList));
        },
        onDone: () {
          log('Connection closed');
          // Handle disconnection
          if (webSocketChannel.closeCode != null) {
            log('Disconnected with close code: ${webSocketChannel.closeCode}');
            log('Disconnected with message: ${webSocketChannel.closeReason}');
            final closingMessage = webSocketChannel.closeReason;

            if (closingMessage != null) {
              emit(HomeState.homeListenerState(
                  showDialogWithString: closingMessage));
            }
          }
        },
        onError: (error) {
          log("Connection error message:- ${error.toString()}");
        },
      );
    } catch (e) {
      log("Error ${e.toString()}");
      emit(HomeState.homeListenerState(errorMessage: e.toString()));
    }
  }

  void sendMessage(String message) {
    try {
      webSocketChannel.sink.add(message);
    } catch (e) {
      log("Error :- ${e.toString()}");
      emit(HomeState.homeListenerState(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    // close the web socket stream
    webSocketChannel.sink.close(2002, "going away");

    return super.close();
  }

  void logout() {
    sharedPreferences.setString(token_key, "");
    sharedPreferences.setString(name_key, "");
    emit(const HomeState.homeListenerState(route: loginScreen));
  }
}
