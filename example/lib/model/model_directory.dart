import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:offline_speech_recognition_example/model/speech_language.dart';
import 'package:path_provider/path_provider.dart';

class DownloadAssetsException implements Exception {
  final Exception exception;
  final String _message;

  DownloadAssetsException(this._message, {this.exception});

  String toString() => exception?.toString() ?? _message;
}

class ModelException implements Exception {
  final Exception exception;
  final String _message;

  ModelException(this._message, {this.exception});

  String toString() => exception?.toString() ?? _message;
}

class SpeechLanguagePath {
  final SpeechLanguage language;
  final String version;
  final String path;

  SpeechLanguagePath({this.language, this.version, this.path});
}

String speechLanguageURL(SpeechLanguage language) {
  switch (language) {
    case SpeechLanguage.english:
      return "vosk-model-small-en-us-0.4.zip";
    case SpeechLanguage.indianEnglish:
      return "vosk-model-small-en-in-0.4.zip";
    case SpeechLanguage.chinese:
      return "vosk-model-small-cn-0.3.zip";
    case SpeechLanguage.russian:
      return "vosk-model-small-ru-0.4.zip";
    case SpeechLanguage.french:
      return "vosk-model-small-fr-pguyot-0.3.zip";
    case SpeechLanguage.german:
      return "vosk-model-small-de-zamia-0.3.zip";
    case SpeechLanguage.spanish:
      return "vosk-model-small-es-0.3.zip";
    case SpeechLanguage.portuguese:
      return "vosk-model-small-pt-0.3.zip";
    case SpeechLanguage.turkish:
      return "vosk-model-small-tr-0.3.zip";
    case SpeechLanguage.vietnamese:
      return "vosk-model-small-vn-0.3.zip";
    case SpeechLanguage.italian:
      return "vosk-model-small-it-0.4.zip";
    case SpeechLanguage.catalan:
      return "vosk-model-small-ca-0.4.zip";
    case SpeechLanguage.farsi:
      return "vosk-model-small-fa-0.4.zip";
  }

  throw ArgumentError('Unknown SpeechLanguage value');
}

SpeechLanguagePath parseLanguagePath(String filepath) {
  String cleanFolder = filepath.split('/').last;
  String cleanZip = cleanFolder.replaceAll('.zip', '');
  List<String> fileParts = cleanZip.split('-');

  // Remove extra information
  List<String> removeExtras = ['vosk', 'model', 'small'];
  fileParts.removeWhere((element) => removeExtras.contains(element));

  // Find version number
  String version = fileParts.last;
  assert(
      double.tryParse(version) != null, 'Version number could not be parsed.');
  fileParts.removeLast();

  // Parse language
  SpeechLanguage language;
  try {
    language = codeToSpeechLanguage(fileParts[0]);
  } catch (_) {
    language = codeToSpeechLanguage(fileParts.join('-'));
  }
  assert(language != null, 'Language could not be parsed');

  return SpeechLanguagePath(
      language: language, version: version, path: cleanFolder);
}

class ModelDirectory {
  static const String _modelBaseURL = "https://alphacephei.com/vosk/models/";
  static String _directory;
  static String get directory => _directory;

  static Future _init({String directory = 'models'}) async {
    if (_directory != null) {
      return;
    }

    String rootDir = (await getApplicationDocumentsDirectory()).path;
    _directory = '$rootDir/$directory';
  }

  static Future dirCreate() async {
    await _init();
    await Directory(_directory).create();
  }

  static Future<bool> dirExists() async {
    await _init();

    return Directory(_directory).exists();
  }

  static Future dirClear() async {
    bool directoryExists = await dirExists();

    if (!directoryExists) return;

    await Directory(_directory).delete(recursive: true);
  }

  static Future<String> getLanguagePath(SpeechLanguage language) async {
    await _init();

    try {
      List<SpeechLanguagePath> languages = await listLanguages();

      List<String> filterAndNormalizeLanguage = languages
          .where((element) => element.language == language)
          .toList()
          .map((language) => '$_directory/${language.path}')
          .toList();

      if (filterAndNormalizeLanguage.isEmpty) {
        throw ModelException('Language not found');
      }

      return filterAndNormalizeLanguage.first;
    } on ModelException {
      rethrow;
    }
  }

  static Future<List<SpeechLanguagePath>> listLanguages() async {
    await _init();

    if (_directory == null) {
      throw ModelException("No Directory");
    }

    List<FileSystemEntity> directoryList =
        Directory(_directory).listSync(followLinks: false, recursive: false);

    if (directoryList.isEmpty) {
      throw ModelException("Nothing found in Directory");
    }

    List<String> folderPaths = [];

    for (FileSystemEntity directory in directoryList) {
      // May require more comprehensive filtering for files in the future.
      if (!directory.path.endsWith('.zip')) {
        folderPaths.add(directory.path);
      }
    }

    if (folderPaths.isEmpty) {
      throw ModelException("No Models Found");
    }

    List<SpeechLanguagePath> downloadedLanguages =
        folderPaths.map((filepath) => parseLanguagePath(filepath)).toList();

    return downloadedLanguages;
  }

  static Future downloadLanguage(
    SpeechLanguage language, {
    Function(double) onProgress,
    Function(Exception) onError,
    Function onComplete,
  }) async {
    String downloadURL;
    String downloadPath;
    await _init();

    try {
      await dirCreate();
      await deleteLanguage(language);

      String speechURL = speechLanguageURL(language);

      downloadURL = '$_modelBaseURL$speechURL';
      downloadPath = '$_directory/$speechURL';
    } catch (e) {
      rethrow;
    }

    try {
      double totalProgress = 0;

      if (onProgress != null) onProgress(0);

      await Dio().download(
        downloadURL,
        downloadPath,
        options: Options(
            headers: {HttpHeaders.acceptEncodingHeader: "*"},
            responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total * 100);
            totalProgress = progress - (progress * 0.2);
          }

          if (onProgress != null)
            onProgress(totalProgress <= 0 ? 0 : totalProgress);
        },
      );

      var zipFile = File(downloadPath);
      var bytes = await zipFile.readAsBytes();
      var archive = ZipDecoder().decodeBytes(bytes);
      await zipFile.delete();
      double totalFiles = archive.length > 0 ? archive.length.toDouble() : 20;
      double increment = 20 / totalFiles;

      for (var file in archive) {
        var filename = '$_directory/${file.name}';

        if (file.isFile) {
          var outFile = File(filename);
          outFile = await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content);
          totalProgress += increment;

          if (onProgress != null) onProgress(totalProgress);
        }
      }

      if (onProgress != null && totalProgress != 100) onProgress(100);

      if (onComplete != null) onComplete();
    } catch (e) {
      DownloadAssetsException downloadAssetsException =
          DownloadAssetsException(e.toString(), exception: e);

      if (onError != null)
        onError(downloadAssetsException);
      else
        throw downloadAssetsException;
    }
  }

  static Future deleteLanguage(SpeechLanguage language) async {
    await _init();

    try {
      String languagePath = await getLanguagePath(language);

      bool languageExists = await Directory(languagePath).exists();

      if (languageExists) {
        await Directory(languagePath).delete(recursive: true);
      }
    } on ModelException {
      return;
    }
  }
}
