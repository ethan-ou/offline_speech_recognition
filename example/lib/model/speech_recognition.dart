import 'package:offline_speech_recognition/model/speech_partial.dart';
import 'package:offline_speech_recognition/model/speech_result.dart';
import 'package:offline_speech_recognition/offline_speech_recognition.dart';
import 'package:offline_speech_recognition_example/model/model_directory.dart';
import 'package:offline_speech_recognition_example/model/speech_language.dart';

class SpeechRecognition {
  static void downloadModel(
    SpeechLanguage language, {
    Function(double) onProgress,
    Function(Exception) onError,
    Function onComplete,
  }) {
    ModelDirectory.downloadLanguage(language,
        onProgress: onProgress, onComplete: onComplete, onError: onError);
  }

  static void deleteModel(SpeechLanguage language) {
    ModelDirectory.deleteLanguage(language);
  }

  static void clearModels() {
    ModelDirectory.dirClear();
  }

  static Future load(SpeechLanguage language) async {
    String languagePath = await ModelDirectory.getLanguagePath(language);

    OfflineSpeechRecognition.load(languagePath);
  }

  static void start() {
    OfflineSpeechRecognition.start();
  }

  static void stop() {
    OfflineSpeechRecognition.stop();
  }

  static void destroy() {
    OfflineSpeechRecognition.destroy();
  }

  static Stream<SpeechPartial> onPartial() {
    return OfflineSpeechRecognition.onPartial();
  }

  static Stream<SpeechResult> onResult() {
    return OfflineSpeechRecognition.onResult();
  }
}
