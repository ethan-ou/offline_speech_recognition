import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:offline_speech_recognition/model/speech_partial.dart';
import 'package:offline_speech_recognition/model/speech_result.dart';

import 'model/speech_recognition_exception.dart';

class OfflineSpeechRecognition {
  static const MethodChannel _channel =
      const MethodChannel('offline_speech_recognition');

  static const EventChannel _resultMessageChannel =
      EventChannel('offline_speech_recognition/result_message');

  static const EventChannel _partialMessageChannel =
      EventChannel('offline_speech_recognition/partial_message');

  static bool _isLoaded = false;

  static Future<void> load(String path) async {
    _isLoaded = false;

    try {
      await _channel.invokeMethod("recognition.load", {'path': path});
      _isLoaded = true;
    } on PlatformException catch (e) {
      throw SpeechRecognitionException(e.code, e.message);
    }
  }

  static Future<void> start() async {
    if (_isLoaded == false) {
      throw SpeechRecognitionException('Speech Recognition not loaded',
          'load method needs to be called before starting recognition.');
    }

    try {
      await _channel.invokeMethod("recognition.start");
    } on PlatformException catch (e) {
      throw SpeechRecognitionException(e.code, e.message);
    }
  }

  static Future<void> stop() async {
    await _channel.invokeMethod("recognition.stop");
  }

  static Future<void> destroy() async {
    await _channel.invokeMethod("recognition.destroy");

    _isLoaded = false;
  }

  static Stream<SpeechResult> _onResult;

  static Stream<SpeechResult> onResult() {
    if (_onResult == null) {
      _onResult = _resultMessageChannel
          .receiveBroadcastStream()
          .map((data) => SpeechResult.fromJson(jsonDecode(data)));
    }
    return _onResult;
  }

  static Stream<SpeechPartial> _onPartial;

  static Stream<SpeechPartial> onPartial() {
    if (_onPartial == null) {
      _onPartial = _partialMessageChannel
          .receiveBroadcastStream()
          .map((data) => SpeechPartial.fromJson(jsonDecode(data)));
    }
    return _onPartial;
  }
}
