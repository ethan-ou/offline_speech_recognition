class SpeechRecognitionException implements Exception {
  SpeechRecognitionException(this.code, this.description);

  String code;
  String description;

  @override
  String toString() => '$runtimeType($code, $description)';
}
