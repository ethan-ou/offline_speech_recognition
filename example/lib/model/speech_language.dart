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

SpeechLanguage codeToSpeechLanguage(String language) {
  switch (language) {
    case "en-us":
      return SpeechLanguage.english;
    case "en-in":
      return SpeechLanguage.indianEnglish;
    case "cn":
      return SpeechLanguage.chinese;
    case "ru":
      return SpeechLanguage.russian;
    case "fr":
      return SpeechLanguage.french;
    case "de":
      return SpeechLanguage.german;
    case "es":
      return SpeechLanguage.spanish;
    case "pt":
      return SpeechLanguage.portuguese;
    case "tr":
      return SpeechLanguage.turkish;
    case "vn":
      return SpeechLanguage.vietnamese;
    case "it":
      return SpeechLanguage.italian;
    case "ca":
      return SpeechLanguage.catalan;
    case "fa":
      return SpeechLanguage.farsi;
  }

  throw ArgumentError('Unknown language string');
}
