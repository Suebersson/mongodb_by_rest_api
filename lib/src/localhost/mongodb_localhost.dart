
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import '../exception.dart';
import './mongodb_handler.dart';

class MongodbLocalhost {

  const MongodbLocalhost({
    required this.socket, 
    required this.streamSubscription,
    required this.isConnected,
  });

  final Socket socket;
  final StreamSubscription streamSubscription;
  final bool isConnected;

  static Future<MongodbLocalhost> connect([final int port = 27017]) async{

    try {

      final Socket socket = await Socket.connect('localhost', port);

      // socket.done.onError((error, stackTrace) {
      //   print('Socket error $error');
      //   throw MongoDBLocalHostExeception('Socket error: $error');
      // },);

      return MongodbLocalhost(
        socket: socket, 
        isConnected: true,
        streamSubscription: socket.transform(const MongoDBHandler().transformer).listen(
          (event) {
          
          },
          cancelOnError: true,
          onDone: () {
            
          },
          onError: (error, stackTrace) {

          },
        ),
      );

    } on HandshakeException catch (error, stackTrace) {
      final String message = 'Falha ao tentar conectar o MongoDB localhost';
      log(
        message,
        error: error,
        name: '$MongodbLocalhost > connectInDataBase',
        stackTrace: stackTrace,
      );
      throw MongoDBExeception(message);
    }

  }

  void sendRequest() {

    final List<int> bytes = [];

    bytes.addAll([]);

    socket.add(bytes);

  }
  
  Future<void> close() async{
    await streamSubscription.cancel();
    await socket.close();
  }

}