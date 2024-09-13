import 'dart:async';
import 'dart:typed_data';

final class MongoDBHandler {

  const  MongoDBHandler();

  void handleData(Uint8List data, EventSink sink) {

  }

  void handleDone(EventSink sink) {

    sink.close();

  }

  StreamTransformer<Uint8List, dynamic> get transformer => StreamTransformer
    .fromHandlers(handleData: handleData, handleDone: handleDone,);

}
