import 'package:flutter/foundation.dart';
import '../core/models/avatar_model.dart';
import '../core/services/storage_service.dart';
import '../core/services/tts_service.dart';

class AvatarProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final TTSService _ttsService = TTSService();

  List<Avatar> _avatars = [];
  Avatar? _selectedAvatar;
  bool _isLoading = false;

  List<Avatar> get avatars => _avatars;
  Avatar? get selectedAvatar => _selectedAvatar;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _storageService.initialize();
      await _ttsService.initialize();
      _avatars = await _storageService.loadAvatars();
      if (_avatars.isNotEmpty) {
        _selectedAvatar = _avatars.first;
      }
    } catch (e) {
      print('Error initializing AvatarProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectAvatar(String avatarId) async {
    try {
      _selectedAvatar = _avatars.firstWhere((a) => a.id == avatarId);
      await _ttsService.setVoice(_selectedAvatar!.voiceType);
      await _ttsService.setSpeechRate(_selectedAvatar!.voiceSpeed);
      notifyListeners();
    } catch (e) {
      print('Error selecting avatar: $e');
    }
  }

  Future<void> selectAvatarForBook(String bookId, String avatarId) async {
    await selectAvatar(avatarId);
    await _storageService.saveAvatarSelection(bookId, avatarId);
  }

  Future<void> loadAvatarForBook(String bookId) async {
    final avatarId = await _storageService.getAvatarSelection(bookId);
    if (avatarId != null) {
      await selectAvatar(avatarId);
    }
  }

  Future<void> previewVoice(String text, String avatarId) async {
    try {
      final avatar = _avatars.firstWhere((a) => a.id == avatarId);
      await _ttsService.setVoice(avatar.voiceType);
      await _ttsService.setSpeechRate(avatar.voiceSpeed);
      await _ttsService.speak(text);
    } catch (e) {
      print('Error previewing voice: $e');
    }
  }

  List<Avatar> getAvatarsByGenre(String genre) {
    return _avatars.where((a) => a.bestFor.contains(genre)).toList();
  }

  Avatar? getAvatarById(String id) {
    try {
      return _avatars.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> setVoiceSpeed(double speed) async {
    if (_selectedAvatar != null) {
      await _ttsService.setSpeechRate(speed);
    }
  }

  Future<void> setVoicePitch(double pitch) async {
    if (_selectedAvatar != null) {
      await _ttsService.setPitch(pitch);
    }
  }
}
