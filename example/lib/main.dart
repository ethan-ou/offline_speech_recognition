import 'package:flutter/material.dart';
import 'package:offline_speech_recognition/model/speech_partial.dart';
import 'dart:async';

import 'package:offline_speech_recognition/offline_speech_recognition.dart';
import 'package:offline_speech_recognition/model/speech_result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
            StreamBuilder(
                stream: OfflineSpeechRecognition.onRecognitionPartial(),
                builder: (BuildContext context,
                    AsyncSnapshot<SpeechPartial> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.text);
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
