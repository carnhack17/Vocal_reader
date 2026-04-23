import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/theme.dart';
import '../../core/models/book_model.dart';
import '../../core/services/tts_service.dart';
import '../../providers/book_provider.dart';
import '../../providers/avatar_provider.dart';

class ReaderScreen extends StatefulWidget {
  final Book book;

  const ReaderScreen({required this.book, Key? key}) : super(key: key);

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late TTSService _ttsService;
  late ScrollController _scrollController;

  int _currentChapterIndex = 0;
  int _currentCharacterIndex = 0;
  bool _isPlaying = false;
  double _speechRate = 0.5;
  double _pitch = 1.0;

  @override
  void initState() {
    super.initState();
    _ttsService = TTSService();
    _scrollController = ScrollController();
    _initializeReader();
  }

  void _initializeReader() async {
    final bookProvider = context.read<BookProvider>();
    final avatarProvider = context.read<AvatarProvider>();

    // Load last reading position
    final lastProgress = await context.read<BookProvider>().currentProgress;
    if (lastProgress != null && lastProgress.bookId == widget.book.id) {
      setState(() {
        _currentChapterIndex = lastProgress.currentChapterIndex;
        _currentCharacterIndex = lastProgress.currentCharacterIndex;
      });
    }

    // Load avatar preferences
    await avatarProvider.loadAvatarForBook(widget.book.id);

    // Set up TTS listeners
    _ttsService.onSpeakComplete(() {
      if (_currentCharacterIndex < _getCurrentChapterText().length - 1) {
        _playNext();
      } else {
        setState(() => _isPlaying = false);
      }
    });

    _ttsService.onSpeakError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
    });
  }

  String _getCurrentChapterText() {
    if (_currentChapterIndex >= widget.book.chapters.length) {
      return '';
    }
    return widget.book.chapters[_currentChapterIndex];
  }

  void _playNext() {
    final text = _getCurrentChapterText();
    if (_currentCharacterIndex < text.length) {
      // Split by sentences
      final sentences = text.split('. ');
      if (_currentCharacterIndex < sentences.length) {
        _ttsService.speak(sentences[_currentCharacterIndex]);
        setState(() => _currentCharacterIndex++);
      }
    }
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _ttsService.pause();
      setState(() => _isPlaying = false);
    } else {
      if (_currentCharacterIndex == 0 && _currentChapterIndex == 0) {
        // First play
        _playNext();
      } else {
        await _ttsService.resume();
      }
      setState(() => _isPlaying = true);
    }
  }

  void _nextChapter() {
    if (_currentChapterIndex < widget.book.chapters.length - 1) {
      setState(() {
        _currentChapterIndex++;
        _currentCharacterIndex = 0;
      });
      _saveProgress();
    }
  }

  void _previousChapter() {
    if (_currentChapterIndex > 0) {
      setState(() {
        _currentChapterIndex--;
        _currentCharacterIndex = 0;
      });
      _saveProgress();
    }
  }

  void _saveProgress() {
    final bookProvider = context.read<BookProvider>();
    final avatarProvider = context.read<AvatarProvider>();
    bookProvider.updateReadingProgress(
      widget.book.id,
      _currentChapterIndex,
      _currentCharacterIndex,
      avatarProvider.selectedAvatar?.id ?? 'default',
    );
  }

  @override
  void dispose() {
    _saveProgress();
    _scrollController.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveProgress();
        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Consumer<AvatarProvider>(
          builder: (context, avatarProvider, _) {
            return SafeArea(
              child: Column(
                children: [
                  // Avatar Display
                  _buildAvatarDisplay(avatarProvider),

                  // Scrollable Text Content
                  Expanded(
                    child: _buildTextContent(),
                  ),

                  // Controls
                  _buildControls(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final progress = (_currentChapterIndex + 1) / widget.book.chapters.length;
    return AppBar(
      title: Column(
        children: [
          Text(
            widget.book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Chapter ${_currentChapterIndex + 1}/${widget.book.chapters.length}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.bgDark,
      foregroundColor: AppColors.textPrimary,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: AppColors.bgSecondary,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarDisplay(AvatarProvider avatarProvider) {
    final avatar = avatarProvider.selectedAvatar;
    if (avatar == null) return const SizedBox();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(
          bottom: BorderSide(color: AppColors.bgTertiary),
        ),
      ),
      child: Row(
        children: [
          // Avatar Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgTertiary,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
            child: const Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          // Avatar Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  avatar.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Narrating "${widget.book.title}"',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          // Status indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isPlaying ? AppColors.secondary : AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    final chapterText = _getCurrentChapterText();

    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chapter Title
            Text(
              'Chapter ${_currentChapterIndex + 1}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Chapter Content - Scrollable with good typography
            SelectableText(
              chapterText,
              style: TextStyle(
                fontSize: 16,
                height: 1.8,
                color: AppColors.textPrimary,
                fontFamily: 'Serif', // Better for reading
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // End of Chapter Indicator
            if (_currentChapterIndex == widget.book.chapters.length - 1)
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.secondary),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      '🎉 Congratulations!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You finished "${widget.book.title}"',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(top: BorderSide(color: AppColors.bgTertiary)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Chapter Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: _currentChapterIndex > 0 ? _previousChapter : null,
                icon: const Icon(Icons.chevron_left),
                label: const Text('Previous'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.5),
                  disabledBackgroundColor:
                      AppColors.textDisabled.withOpacity(0.2),
                ),
              ),
              Text(
                '${_currentChapterIndex + 1}/${widget.book.chapters.length}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _currentChapterIndex < widget.book.chapters.length - 1
                    ? _nextChapter
                    : null,
                icon: const Icon(Icons.chevron_right),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.5),
                  disabledBackgroundColor:
                      AppColors.textDisabled.withOpacity(0.2),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Speed & Pitch Controls
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Speed: ${(_speechRate * 2).toStringAsFixed(1)}x',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    Slider(
                      value: _speechRate,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.bgTertiary,
                      onChanged: (value) {
                        setState(() => _speechRate = value);
                        _ttsService.setSpeechRate(value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pitch: ${_pitch.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    Slider(
                      value: _pitch,
                      min: 0.5,
                      max: 2.0,
                      divisions: 10,
                      activeColor: AppColors.secondary,
                      inactiveColor: AppColors.bgTertiary,
                      onChanged: (value) {
                        setState(() => _pitch = value);
                        _ttsService.setPitch(value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Play/Pause Button - Main CTA
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.gradientPrimary,
              borderRadius: BorderRadius.circular(AppRadius.large),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _togglePlayPause,
                borderRadius: BorderRadius.circular(AppRadius.large),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.lg,
                    horizontal: AppSpacing.xl,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        _isPlaying ? 'Pause' : 'Play Narration',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
