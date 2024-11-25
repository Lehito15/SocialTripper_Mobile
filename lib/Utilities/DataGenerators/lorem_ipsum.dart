import 'dart:math';

class LoremIpsumGenerator {
  static final List<String> _words = [
    "lorem", "ipsum", "dolor", "sit", "amet", "consectetur",
    "adipiscing", "elit", "sed", "do", "eiusmod", "tempor",
    "incididunt", "ut", "labore", "et", "dolore", "magna", "aliqua"
  ];

  static final Random _random = Random();

  /// Generuje tekst Lorem Ipsum o określonej maksymalnej długości.
  static String generate({int maxLength = 128}) {
    if (maxLength <= 0) {
      return ""; // Jeśli maxLength <= 0, zwróć pusty string
    }

    List<String> result = [];
    int currentLength = 0;

    while (currentLength < maxLength) {
      int wordCount = _random.nextInt(8) + 3; // Liczba słów w zdaniu (3–10)
      String sentence = _generateSentence(wordCount);

      // Dodaj kropkę na końcu zdania
      sentence = sentence[0].toUpperCase() + sentence.substring(1) + ".";

      if (currentLength + sentence.length > maxLength) {
        // Skróć zdanie, jeśli przekracza limit długości
        int remainingLength = maxLength - currentLength;
        sentence = sentence.substring(0, remainingLength - 1) + ".";
      }

      result.add(sentence);
      currentLength += sentence.length;

      if (currentLength >= maxLength) break;
    }

    return result.join(" ");
  }

  /// Tworzy jedno zdanie z losowej liczby słów.
  static String _generateSentence(int wordCount) {
    return List.generate(wordCount, (_) => _randomWord()).join(" ");
  }

  /// Pobiera losowe słowo z listy.
  static String _randomWord() {
    return _words[_random.nextInt(_words.length)];
  }
}