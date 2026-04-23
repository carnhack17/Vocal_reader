import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/avatar_model.dart';
import '../models/book_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  late Directory _appDocDir;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  Future<void> initialize() async {
    _appDocDir = await getApplicationDocumentsDirectory();

    // Create subdirectories
    await Directory('${_appDocDir.path}/books').create(recursive: true);
    await Directory('${_appDocDir.path}/avatars').create(recursive: true);
    await Directory('${_appDocDir.path}/data').create(recursive: true);
  }

  // ========== AVATAR MANAGEMENT ==========

  Future<List<Avatar>> loadAvatars() async {
    try {
      final file = File('${_appDocDir.path}/data/avatars.json');
      if (!file.existsSync()) {
        return _getDefaultAvatars(); // Return 20 built-in avatars
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Avatar.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error loading avatars: $e');
      return _getDefaultAvatars();
    }
  }

  Future<void> saveAvatarSelection(String bookId, String avatarId) async {
    try {
      final file = File('${_appDocDir.path}/data/avatar_selections.json');
      Map<String, dynamic> selections = {};

      if (file.existsSync()) {
        selections = jsonDecode(await file.readAsString());
      }

      selections[bookId] = avatarId;
      await file.writeAsString(jsonEncode(selections));
    } catch (e) {
      print('Error saving avatar selection: $e');
    }
  }

  Future<String?> getAvatarSelection(String bookId) async {
    try {
      final file = File('${_appDocDir.path}/data/avatar_selections.json');
      if (!file.existsSync()) return null;

      final selections = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return selections[bookId] as String?;
    } catch (e) {
      print('Error getting avatar selection: $e');
      return null;
    }
  }

  // ========== BOOK MANAGEMENT ==========

  Future<List<Book>> loadBooks() async {
    try {
      final file = File('${_appDocDir.path}/data/books.json');
      if (!file.existsSync()) return [];

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Book.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error loading books: $e');
      return [];
    }
  }

  Future<void> saveBooks(List<Book> books) async {
    try {
      final file = File('${_appDocDir.path}/data/books.json');
      final jsonString = jsonEncode(books.map((b) => b.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving books: $e');
    }
  }

  Future<void> saveReadingProgress(ReadingProgress progress) async {
    try {
      final file = File('${_appDocDir.path}/data/reading_progress.json');
      Map<String, dynamic> progressMap = {};

      if (file.existsSync()) {
        progressMap = jsonDecode(await file.readAsString());
      }

      progressMap[progress.bookId] = progress.toJson();
      await file.writeAsString(jsonEncode(progressMap));
    } catch (e) {
      print('Error saving reading progress: $e');
    }
  }

  Future<ReadingProgress?> getReadingProgress(String bookId) async {
    try {
      final file = File('${_appDocDir.path}/data/reading_progress.json');
      if (!file.existsSync()) return null;

      final progressMap = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      if (progressMap.containsKey(bookId)) {
        return ReadingProgress.fromJson(progressMap[bookId] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting reading progress: $e');
      return null;
    }
  }

  // ========== SETTINGS ==========

  Future<Map<String, dynamic>> loadSettings() async {
    try {
      final file = File('${_appDocDir.path}/data/settings.json');
      if (!file.existsSync()) {
        return {'theme': 'dark', 'speechRate': 0.5, 'pitch': 1.0};
      }
      return jsonDecode(await file.readAsString());
    } catch (e) {
      print('Error loading settings: $e');
      return {'theme': 'dark', 'speechRate': 0.5, 'pitch': 1.0};
    }
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    try {
      final file = File('${_appDocDir.path}/data/settings.json');
      await file.writeAsString(jsonEncode(settings));
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  // ========== DEFAULT DATA ==========

  List<Avatar> _getDefaultAvatars() {
    return [
      Avatar(
        id: 'elyas',
        name: 'Elyas',
        imagePath: 'assets/avatars/elyas/image.png',
        voiceType: 'en-US-1',
        personality: 'mysterious',
        bestFor: ['fantasy', 'thriller', 'mystery'],
        description: 'A mysterious wanderer with a deep, compelling voice',
      ),
      Avatar(
        id: 'mira',
        name: 'Mira',
        imagePath: 'assets/avatars/mira/image.png',
        voiceType: 'en-US-2',
        personality: 'adventurous',
        bestFor: ['adventure', 'fantasy', 'sci-fi'],
        description: 'An adventurous spirit ready for any journey',
      ),
      Avatar(
        id: 'kael',
        name: 'Kael',
        imagePath: 'assets/avatars/kael/image.png',
        voiceType: 'en-US-3',
        personality: 'calm',
        bestFor: ['romance', 'drama', 'literary'],
        description: 'A calm, soothing presence for intimate stories',
      ),
      Avatar(
        id: 'iris',
        name: 'Iris',
        imagePath: 'assets/avatars/iris/image.png',
        voiceType: 'en-US-4',
        personality: 'energetic',
        bestFor: ['action', 'sci-fi', 'young-adult'],
        description: 'A vibrant, energetic narrator full of life',
      ),
      Avatar(
        id: 'zephyr',
        name: 'Zephyr',
        imagePath: 'assets/avatars/zephyr/image.png',
        voiceType: 'en-US-5',
        personality: 'poetic',
        bestFor: ['poetry', 'literary', 'romance'],
        description: 'A poetic soul who brings rhythm to stories',
      ),
      // Add 15 more avatars in production...
      // For MVP, we'll use these 5 and expand later
    ];
  }
}
