import 'package:intl/intl.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String filePath;
  final String fileType; // 'epub', 'txt', 'pdf'
  final String? coverImagePath;
  final String genre;
  final List<String> chapters;
  final DateTime dateAdded;
  final ReadingProgress? lastProgress;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.filePath,
    required this.fileType,
    this.coverImagePath,
    required this.genre,
    required this.chapters,
    required this.dateAdded,
    this.lastProgress,
  });

  int get totalWords => chapters.fold(0, (sum, ch) => sum + (ch.split(' ').length));

  double get readingProgress =>
      lastProgress != null ? (lastProgress!.currentChapterIndex / chapters.length) : 0;

  String get displayDate => DateFormat('MMM d, yyyy').format(dateAdded);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'author': author,
    'filePath': filePath,
    'fileType': fileType,
    'coverImagePath': coverImagePath,
    'genre': genre,
    'chapters': chapters,
    'dateAdded': dateAdded.toIso8601String(),
    'lastProgress': lastProgress?.toJson(),
  };

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json['id'] as String,
    title: json['title'] as String,
    author: json['author'] as String,
    filePath: json['filePath'] as String,
    fileType: json['fileType'] as String,
    coverImagePath: json['coverImagePath'] as String?,
    genre: json['genre'] as String,
    chapters: List<String>.from(json['chapters'] as List),
    dateAdded: DateTime.parse(json['dateAdded'] as String),
    lastProgress: json['lastProgress'] != null
        ? ReadingProgress.fromJson(json['lastProgress'] as Map<String, dynamic>)
        : null,
  );
}

class ReadingProgress {
  final String bookId;
  final String selectedAvatarId;
  final int currentChapterIndex;
  final int currentCharacterIndex;
  final DateTime lastReadAt;
  final int readingStreak; // consecutive days

  ReadingProgress({
    required this.bookId,
    required this.selectedAvatarId,
    required this.currentChapterIndex,
    required this.currentCharacterIndex,
    required this.lastReadAt,
    this.readingStreak = 0,
  });

  Map<String, dynamic> toJson() => {
    'bookId': bookId,
    'selectedAvatarId': selectedAvatarId,
    'currentChapterIndex': currentChapterIndex,
    'currentCharacterIndex': currentCharacterIndex,
    'lastReadAt': lastReadAt.toIso8601String(),
    'readingStreak': readingStreak,
  };

  factory ReadingProgress.fromJson(Map<String, dynamic> json) => ReadingProgress(
    bookId: json['bookId'] as String,
    selectedAvatarId: json['selectedAvatarId'] as String,
    currentChapterIndex: json['currentChapterIndex'] as int,
    currentCharacterIndex: json['currentCharacterIndex'] as int,
    lastReadAt: DateTime.parse(json['lastReadAt'] as String),
    readingStreak: json['readingStreak'] as int? ?? 0,
  );
}
