// Named the class as text for better consistency with the result class.
// Not sure whether this is the best decision yet.

// This pushes the complexity down a little. But it's more contextually right.
class SpeechPartial {
  final String text;

  SpeechPartial(this.text);

  SpeechPartial.fromJson(Map<String, dynamic> json) : text = json['partial'];

  Map<String, String> toJson() => {
        'partial': text,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
