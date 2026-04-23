import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  final FlutterTts _tts = FlutterTts();

  factory TTSService() {
    return _instance;
  }

  TTSService._internal();

  Future<void> initialize() async {
    await _tts.awaitSpeakCompletion(true);
  }

  Future<void> speak(String text, {
    String language = 'en-US',
    double rate = 0.5, // 0.0 to 1.0
    double pitch = 1.0,
  }) async {
    await _tts.setLanguage(language);
    await _tts.setSpeechRate(rate);
    await _tts.setPitch(pitch);
    await _tts.speak(text);
  }

  Future<void> pause() async {
    await _tts.pause();
  }

  Future<void> resume() async {
    await _tts.resume();
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> setVoice(String voiceType) async {
    // Platform-specific voice selection
    // voiceType examples: "en-US-1", "en-GB-1", etc.
    await _tts.setVoice({'name': voiceType, 'locale': 'en-US'});
  }

  Future<void> setSpeechRate(double rate) async {
    // rate: 0.0 (slowest) to 1.0 (fastest), default 0.5
    await _tts.setSpeechRate(rate);
  }

  Future<void> setPitch(double pitch) async {
    // pitch: 0.5 (lowest) to 2.0 (highest), default 1.0
    await _tts.setPitch(pitch);
  }

  // Event listeners
  void onSpeakStart(Function() callback) {
    _tts.setStartHandler(callback);
  }

  void onSpeakComplete(Function() callback) {
    _tts.setCompletionHandler(callback);
  }

  void onSpeakError(Function(String) callback) {
    _tts.setErrorHandler((dynamic msg) {
      callback(msg.toString());
    });
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}
