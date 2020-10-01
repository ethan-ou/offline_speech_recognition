class SpeechPartialResult {
  final String partial;

  SpeechPartialResult(this.partial);

  SpeechPartialResult.fromJson(Map<String, dynamic> json)
      : partial = json['partial'];

  Map<String, dynamic> toJson() => {
        'partial': partial,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
