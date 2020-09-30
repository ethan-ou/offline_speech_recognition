import 'package:flutter_test/flutter_test.dart';
import 'package:offline_speech_recognition/model_downloader.dart';

void main() {
  group('Counter', () {
    test('Should Download', () async {
      await ModelDownloader.init();

      Future _downloadAssets() async {
        bool assetsDownloaded = await ModelDownloader.assetsDirAlreadyExists();

        if (assetsDownloaded) {
          print("Assets Downloaded Already");
          return;
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

      Future _refresh() async {
        await ModelDownloader.clearAssets();
        await _downloadAssets();
      }

      await _downloadAssets();
      expect(
          ModelDownloader.assetsDirAlreadyExists(), completion(equals(true)));
      await ModelDownloader.clearAssets();
    }, timeout: Timeout(Duration(minutes: 5)));
  });
}
