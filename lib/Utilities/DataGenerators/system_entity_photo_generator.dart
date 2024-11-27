class SystemEntityPhotoGenerator {
  static Future<String> fetchRandomImage() async {
    final randomUrl = 'https://random.danielpetrica.com/api/random?${DateTime.now().microsecondsSinceEpoch}';
    return randomUrl;
  }
}