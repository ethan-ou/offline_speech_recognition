
import 'dart:async';

import 'package:flutter/services.dart';

class OfflineSpeechRecognition {
  static const MethodChannel _channel =
      const MethodChannel('offline_speech_recognition');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
