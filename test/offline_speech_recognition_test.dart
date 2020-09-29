import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_speech_recognition/offline_speech_recognition.dart';

void main() {
  const MethodChannel channel = MethodChannel('offline_speech_recognition');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await OfflineSpeechRecognition.platformVersion, '42');
  });
}
