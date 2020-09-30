import 'dart:async';

import 'package:flutter/services.dart';

class OfflineSpeechRecognition {
  static const MethodChannel _channel =
      const MethodChannel('offline_speech_recognition');

  static const EventChannel eventChannel =
      EventChannel('offline_speech_recognition/message');

  static Future<void> init() async {
    await _channel.invokeMethod("recognition.init");
  }

  static Future<void> load() async {
    await _channel
        .invokeMethod("recognition.load", <String, String>{'path': "./"});
  }

  // Stream<RecognitionResult> _onRecognitionResult;
  //
  // Stream<RecognitionResult> _onRecognitionResult() {
  //   if (_onRecognitionResult == null) {
  //     _onRecognitionResult = eventChannel.receiveBroadcastStream().map((event) => //TODO);
  //   }
  //
  //   return _onRecognitionResult;
  // }
}

// RecognitionResult _parseRecognitionResult(Map<String, String> state) {
//
// }
