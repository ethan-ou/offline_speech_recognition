class SpeechResult {
  final String text;

  SpeechResult(this.text);

  SpeechResult.fromJson(Map<String, dynamic> json) : text = json['text'];

  Map<String, dynamic> toJson() => {
        'text': text,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
