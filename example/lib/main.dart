import 'package:flutter/material.dart';
import 'package:offline_speech_recognition/model/speech_partial.dart';

import 'package:offline_speech_recognition_example/model/speech_language.dart';

import 'model/speech_recognition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBody();
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  double downloadProgress = 0.0;
  bool downloading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              StreamBuilder(
                  stream: SpeechRecognition.onPartial(),
                  builder: (BuildContext context,
                      AsyncSnapshot<SpeechPartial> snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.partial);
                    } else {
                      return Text("No Data Yet");
                    }
                  }),
              if (downloading == true)
                LinearProgressIndicator(value: downloadProgress),
              RaisedButton(
                  child: Text("Download"),
                  onPressed: () {
                    SpeechRecognition.downloadModel(SpeechLanguage.chinese,
                        onProgress: (progress) {
                      setState(() {
                        downloading = true;
                        downloadProgress = progress;
                      });
                    }, onComplete: () {
                      setState(() {
                        downloading = false;
                      });
                    });
                  }),
              RaisedButton(
                  child: Text("Load"),
                  onPressed: () {
                    SpeechRecognition.load(SpeechLanguage.chinese);
                  }),
              RaisedButton(
                  child: Text("Start/Stop"),
                  onPressed: () {
                    SpeechRecognition.start();
                  }),
              RaisedButton(
                  child: Text("Delete Language"),
                  onPressed: () {
                    SpeechRecognition.destroy();
                    SpeechRecognition.deleteModel(SpeechLanguage.chinese);
                  }),
              RaisedButton(
                  child: Text("Delete All Languages"),
                  onPressed: () {
                    SpeechRecognition.destroy();
                    SpeechRecognition.clearModels();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
