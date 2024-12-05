enum Mood {
  happy,
  sad,
  angry,
  excited,
  bored,
}

extension MoodExtention on Mood {
  String get name {
    switch (this) {
      case Mood.happy:
        return "Happy";

      case Mood.sad:
        return "sad";

      case Mood.angry:
        return "angry";

      case Mood.bored:
        return "bored";

      case Mood.excited:
        return "excited";

      default:
        return "";
    }
  }

  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😊'; // Happy emoji
      case Mood.sad:
        return '😢'; // Sad emoji
      case Mood.angry:
        return '😡'; // Angry emoji
      case Mood.excited:
        return '🤩'; // Excited emoji
      case Mood.bored:
        return '😴'; // Bored emoji
      default:
        return '';
    }
  }

  static Mood formString(String moodString) {
    return Mood.values.firstWhere((mood) => mood.name == moodString,
        orElse: () => Mood.happy);
  }
}
