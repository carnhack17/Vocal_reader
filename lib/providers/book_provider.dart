import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../core/models/book_model.dart';
import '../core/services/storage_service.dart';

class BookProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Book> _books = [];
  Book? _currentBook;
  ReadingProgress? _currentProgress;
  bool _isLoading = false;

  List<Book> get books => _books;
  Book? get currentBook => _currentBook;
  ReadingProgress? get currentProgress => _currentProgress;
  bool get isLoading => _isLoading;
  Book? get lastReadBook => _books.isNotEmpty ? _books.first : null;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _storageService.initialize();
      _books = await _storageService.loadBooks();
      // Sort by most recent first
      _books.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    } catch (e) {
      print('Error initializing BookProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBook(String title, String author, String filePath,
      String fileType, String genre, List<String> chapters) async {
    final book = Book(
      id: const Uuid().v4(),
      title: title,
      author: author,
      filePath: filePath,
      fileType: fileType,
      genre: genre,
      chapters: chapters,
      dateAdded: DateTime.now(),
    );

    _books.insert(0, book); // Add to top (most recent)
    await _storageService.saveBooks(_books);
    notifyListeners();
  }

  Future<void> removeBook(String bookId) async {
    _books.removeWhere((b) => b.id == bookId);
    await _storageService.saveBooks(_books);
    if (_currentBook?.id == bookId) {
      _currentBook = null;
      _currentProgress = null;
    }
    notifyListeners();
  }

  Future<void> selectBook(String bookId) async {
    _currentBook = _books.firstWhere((b) => b.id == bookId);
    _currentProgress = await _storageService.getReadingProgress(bookId);
    notifyListeners();
  }

  Future<void> updateReadingProgress(
    String bookId,
    int currentChapterIndex,
    int currentCharacterIndex,
    String selectedAvatarId,
  ) async {
    final progress = ReadingProgress(
      bookId: bookId,
      selectedAvatarId: selectedAvatarId,
      currentChapterIndex: currentChapterIndex,
      currentCharacterIndex: currentCharacterIndex,
      lastReadAt: DateTime.now(),
      readingStreak: _calculateReadingStreak(),
    );

    await _storageService.saveReadingProgress(progress);
    _currentProgress = progress;

    // Update book's last progress
    final bookIndex = _books.indexWhere((b) => b.id == bookId);
    if (bookIndex != -1) {
      _books[bookIndex] = _books[bookIndex];
    }

    notifyListeners();
  }

  int _calculateReadingStreak() {
    if (_currentProgress == null) return 1;

    final today = DateTime.now();
    final lastRead = _currentProgress!.lastReadAt;

    if (lastRead.day == today.day && lastRead.month == today.month) {
      // Same day - no change
      return _currentProgress!.readingStreak;
    } else if (lastRead.day == today.day - 1 ||
        (lastRead.day == 28 &&
            today.day == 1)) { // Simple month-end handling
      // Consecutive day
      return _currentProgress!.readingStreak + 1;
    } else {
      // Streak broken
      return 1;
    }
  }

  Book? getBookById(String id) {
    try {
      return _books.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Book> searchBooks(String query) {
    if (query.isEmpty) return _books;
    return _books
        .where((b) =>
            b.title.toLowerCase().contains(query.toLowerCase()) ||
            b.author.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Book> getBooksByGenre(String genre) {
    return _books.where((b) => b.genre == genre).toList();
  }
}
