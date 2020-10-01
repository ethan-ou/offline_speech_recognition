import 'package:flutter/material.dart';
import 'package:offline_speech_recognition/model/speech_partial_result.dart';
import 'dart:async';

import 'package:offline_speech_recognition/offline_speech_recognition.dart';
import 'package:offline_speech_recognition/model/speech_result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await OfflineSpeechRecognition.init();
    } on Exception {
      print("Exception!");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = "Works!";
    });
  }

  Future<void> initSpeechRecognition() async {
    try {
      await OfflineSpeechRecognition.load();
    } on Exception {
      print("Exception!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            StreamBuilder(
                stream: OfflineSpeechRecognition.onRecognitionPartial(),
                builder: (BuildContext context,
                    AsyncSnapshot<SpeechPartialResult> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.partial);
                  } else {
                    return Text("No Data Yet");
                  }
                }),
            FlatButton(
                child: Text("Start"),
                onPressed: () async {
                  await OfflineSpeechRecognition.start();
                }),
            FlatButton(
                child: Text("Delete Assets"),
                onPressed: () async {
                  await OfflineSpeechRecognition.destroy();
                  await OfflineSpeechRecognition.clearAssets();
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Add your onPressed code here!
            await initSpeechRecognition();
          },
          child: Icon(Icons.navigation),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}
