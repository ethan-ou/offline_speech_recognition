class SpeechPartial {
  final String partial;

  SpeechPartial(this.partial);

  SpeechPartial.fromJson(Map<String, dynamic> json) : partial = json['partial'];

  Map<String, String> toJson() => {
        'partial': partial,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
