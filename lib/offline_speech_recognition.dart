import 'dart:async';

import 'package:flutter/services.dart';
import 'package:offline_speech_recognition/model_downloader.dart';

class OfflineSpeechRecognition {
  static const MethodChannel _channel =
      const MethodChannel('offline_speech_recognition');

  static const EventChannel _resultMessageChannel =
      EventChannel('offline_speech_recognition/result_message');

  static const EventChannel _partialMessageChannel =
      EventChannel('offline_speech_recognition/partial_message');

  static Future<void> init() async {
    await _channel.invokeMethod("recognition.init");
  }

  static Future<String> downloadAssets() async {
    await ModelDownloader.init();

    Future _downloadAssets() async {
      bool assetsDownloaded = await ModelDownloader.assetsDirAlreadyExists();

      if (assetsDownloaded) {
        return ModelDownloader.assetsDir;
      }

      try {
        await ModelDownloader.startDownload(
            assetsUrl:
                "http://alphacephei.com/vosk/models/vosk-model-small-en-us-0.3.zip",
            onProgress: (progressValue) {
              print(progressValue);
            },
            onComplete: () {
              print("Complete");
            },
            onError: (exception) {
              print(exception);
            });
      } on DownloadAssetsException catch (e) {
        print(e.toString());
      }
    }

    await _downloadAssets();
    return ModelDownloader.assetsDir;
  }

  static Future<void> clearAssets() async {
    await ModelDownloader.clearAssets();
  }

  static Future<void> load() async {
    String path = await downloadAssets() + "/vosk-model-small-en-us-0.3";
    print(path);
    await _channel
        .invokeMethod("recognition.load", <String, String>{'path': path});
  }

  static Future<void> start() async {
    await _channel.invokeMethod("recognition.start");
  }

  static Future<void> stop() async {
    await _channel.invokeMethod("recognition.stop");
  }

  static Future<void> destroy() async {
    await _channel.invokeMethod("recognition.destroy");
  }

  static Stream<String> _onRecognitionResult;

  static Stream<String> onRecognitionResult() {
    if (_onRecognitionResult == null) {
      _onRecognitionResult =
          _resultMessageChannel.receiveBroadcastStream().map((value) => value);
    }

    return _onRecognitionResult;
  }

  static Stream<String> _onRecognitionPartial;

  static Stream<String> onRecognitionPartial() {
    if (_onRecognitionPartial == null) {
      _onRecognitionPartial =
          _partialMessageChannel.receiveBroadcastStream().map((value) => value);
    }

    return _onRecognitionPartial;
  }
}
