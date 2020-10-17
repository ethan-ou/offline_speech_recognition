enum SpeechLanguage {
  english,
  indianEnglish,
  chinese,
  russian,
  french,
  german,
  spanish,
  portuguese,
  turkish,
  vietnamese,
  italian,
  catalan,
  farsi
}

String serializeSpeechLanguage(SpeechLanguage language) {
  switch (language) {
    case SpeechLanguage.english:
      return "english";
    case SpeechLanguage.indianEnglish:
      return "indianEnglish";
    case SpeechLanguage.chinese:
      return "chinese";
    case SpeechLanguage.russian:
      return "russian";
    case SpeechLanguage.french:
      return "french";
    case SpeechLanguage.german:
      return "german";
    case SpeechLanguage.spanish:
      return "spanish";
    case SpeechLanguage.portuguese:
      return "portuguese";
    case SpeechLanguage.turkish:
      return "turkish";
    case SpeechLanguage.vietnamese:
      return "vietnamese";
    case SpeechLanguage.italian:
      return "italian";
    case SpeechLanguage.catalan:
      return "catalan";
    case SpeechLanguage.farsi:
      return "farsi";
  }

  throw ArgumentError('Unknown SpeechLanguage value');
}

String speechLanguageToCode(SpeechLanguage language) {
  switch (language) {
    case SpeechLanguage.english:
      return "en";
    case SpeechLanguage.indianEnglish:
      return "en-in";
    case SpeechLanguage.chinese:
      return "cn";
    case SpeechLanguage.russian:
      return "ru";
    case SpeechLanguage.french:
      return "fr";
    case SpeechLanguage.german:
      return "de";
    case SpeechLanguage.spanish:
      return "es";
    case SpeechLanguage.portuguese:
      return "pt";
    case SpeechLanguage.turkish:
      return "tr";
    case SpeechLanguage.vietnamese:
      return "vn";
    case SpeechLanguage.italian:
      return "it";
    case SpeechLanguage.catalan:
      return "ca";
    case SpeechLanguage.farsi:
      return "fa";
  }

  throw ArgumentError('Unknown SpeechLanguage value');
}
