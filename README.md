# 📖 Storyteller - Offline Audiobook Reader with Avatar Narrators

A **stunning Flutter app** that transforms your reading experience with **offline text-to-speech narration** and **20 unique avatar narrators**. Read your novels while listening to them narrated in real-time.

## ✨ Key Features

### 🎯 Core Experience
- **📖 Multi-Format Support**: Import EPUB, TXT, and PDF files
- **🗣️ Offline Voice Narration**: Full TTS support without internet
- **🎭 20 Avatar Narrators**: Choose your favorite character voice to accompany you
- **📱 100% Offline**: Works completely offline after first install
- **⚡ Smooth Scrolling**: Read text while listening in perfect sync

### 🎨 Addictive Design
- **👁️ Avatar Spotlight**: Beautiful avatar display on home screen
- **⚡ One-Tap Resume**: "Continue Reading" instantly takes you back
- **🔥 Reading Streaks**: Track consecutive reading days for engagement
- **📊 Progress Tracking**: Visual indicators for book completion
- **🎉 Celebration Moments**: Get rewarded when finishing chapters
- **🌈 Premium Dark Theme**: Eye-friendly interface designed for long reading sessions

### 🎧 Voice Control
- **⏸️ Play/Pause/Resume**: Intuitive playback controls
- **🎚️ Speed Control**: Adjust narration speed (0.5x to 2x)
- **🎵 Pitch Control**: Customize voice pitch for comfort
- **🎯 Chapter Navigation**: Jump between chapters easily

### 💾 Smart Storage
- **📚 Library Management**: Organize all your books
- **🔖 Auto-Bookmarks**: Remember exactly where you left off
- **⭐ Genre Filtering**: Find books by category
- **🔍 Search**: Quick access to any book in your library

---

## 🏗️ Project Structure

```
lib/
│
├── main.dart                          # App entry point
│
├── core/
│   ├── constants/
│   │   └── theme.dart                 # Color scheme, typography, spacing
│   ├── models/
│   │   ├── avatar_model.dart          # Avatar data structure
│   │   └── book_model.dart            # Book & reading progress
│   └── services/
│       ├── tts_service.dart           # Text-to-speech engine
│       ├── audio_service.dart         # Audio playback control
│       └── storage_service.dart       # Local file & data storage
│
├── providers/
│   ├── book_provider.dart             # Book state management
│   └── avatar_provider.dart           # Avatar state management
│
├── features/
│   ├── home/
│   │   └── home_screen.dart           # Landing screen with continue reading
│   ├── reader/
│   │   └── reader_screen.dart         # Main reading experience
│   ├── library/
│   │   └── library_screen.dart        # Book management
│   ├── avatars/
│   │   └── avatar_screen.dart         # Avatar selection
│   └── settings/
│       └── settings_screen.dart       # User preferences
│
├── widgets/
│   └── avatar_display_widget.dart     # Avatar UI component
│
└── assets/
    ├── avatars/                       # Avatar images & metadata
    └── sample_books/                  # Pre-loaded sample books
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.0+
- Dart 3.0+
- Android SDK 21+ or iOS 12+

### Installation

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd storyteller_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add required fonts** (optional, for custom typography)
   - Create `assets/fonts/` directory
   - Add Poppins font files

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🎭 Avatar System

### How It Works
Each avatar has:
- **Unique personality** (mysterious, adventurous, calm, energetic, poetic)
- **Optimized voice type** (different TTS engine voice profiles)
- **Genre recommendations** (what type of books they're best for)
- **Custom voice settings** (speed, pitch preferences)

### Available Avatars (Sample)
| Avatar | Personality | Best For | Voice |
|--------|-------------|----------|-------|
| Elyas | Mysterious | Fantasy, Thriller | Deep, Compelling |
| Mira | Adventurous | Adventure, Sci-Fi | Energetic, Dynamic |
| Kael | Calm | Romance, Drama | Soothing, Warm |
| Iris | Energetic | Action, Young-Adult | Vibrant, Upbeat |
| Zephyr | Poetic | Literary, Poetry | Rhythmic, Artistic |

**Expand to 20 avatars** by adding more to `_getDefaultAvatars()` in `storage_service.dart`

---

## 🎨 Design Psychology - Why It's Addictive

### Activation Loop
```
Import Book → Choose Avatar → Press Play → Avatar + Voice Appear
    ↓
DOPAMINE HIT (emotional connection + sensory experience)
```

### Retention Mechanics

1. **Frictionless Re-entry**: "Continue Reading" button on home screen
   - User sees last book + progress immediately
   - One tap to resume
   
2. **Progress Visualization**: 
   - Chapter completion percentage
   - Reading streak counter (🔥)
   - Visual progress bar
   
3. **Avatar Personality**:
   - Makes reading feel like a relationship with the narrator
   - Different avatars for different genres
   - Voice preview before committing

4. **Micro-Wins**:
   - Finishing a chapter triggers celebration
   - Progress bars fill up (satisfying)
   - Streak mechanic rewards consistency

5. **Habit Formation**:
   - Reading streak tracking
   - Auto-resume to last position
   - Daily reminders (optional)

---

## 🛠️ Key Technologies

### State Management
- **Provider**: Simple, reactive state management
- **ChangeNotifier**: Automatic UI rebuilds on data changes

### Text-to-Speech
- **flutter_tts**: Offline TTS with platform-native voices
- **Alternative**: Native Piper TTS integration (advanced)

### File Handling
- **file_picker**: Import books from device
- **path_provider**: Secure local storage
- **epubx**: Parse EPUB files

### Storage
- **sqflite**: Optional SQLite for advanced tracking
- **JSON files**: Lightweight progress/settings storage

### UI Polish
- **lottie**: Avatar animations
- **google_fonts**: Premium typography
- **flutter_animate**: Smooth transitions

---

## 📱 User Flow

```
Launch App
    ↓
[Home Screen]
    ├─ Avatar Spotlight (engaging)
    ├─ Continue Reading (frictionless)
    ├─ Reading Stats (gamification)
    └─ Recent Books (quick access)
    ↓
[Select Book]
    ↓
[Choose Avatar]
    ↓
[Reader Screen]
    ├─ Avatar Display (top)
    ├─ Scrollable Text (center)
    ├─ Play/Pause Controls (bottom)
    ├─ Speed/Pitch Sliders
    └─ Chapter Navigation
    ↓
[Reading Progress Saved]
    ↓
[Next session: Auto-resume]
```

---

## ⚙️ Configuration

### Change Default Theme
Edit `lib/core/constants/theme.dart`:
```dart
// Customize colors
static const primary = Color(0xFF6B4EFF);      // Change this
static const secondary = Color(0xFFFF6B9D);   // Or this
static const accent = Color(0xFF4ECDC4);      // Or this
```

### Add More Avatars
Edit `lib/core/services/storage_service.dart` → `_getDefaultAvatars()`:
```dart
Avatar(
  id: 'your_avatar_id',
  name: 'Avatar Name',
  imagePath: 'assets/avatars/your_avatar/image.png',
  voiceType: 'en-US-1',
  personality: 'your_personality',
  bestFor: ['genre1', 'genre2'],
  description: 'Your description',
)
```

### Customize Settings
Edit `lib/features/settings/settings_screen.dart` to add more options

---

## 🔄 Reading Progress System

### What Gets Saved
- **Book position**: Current chapter & character index
- **Selected avatar**: Which narrator is active
- **Reading streak**: Consecutive days read
- **Last read time**: When user last opened this book

### Auto-Save
Progress is automatically saved when:
- User navigates away from reader screen
- App is closed (via `WillPopScope`)
- Chapter changes
- Every time voice playback completes

---

## 🎯 MVP vs Future Features

### ✅ MVP (Current)
- Import TXT/EPUB files
- TTS narration
- Avatar display
- Play/pause control
- Progress tracking
- Settings

### 🚀 Future Enhancements
- Cloud sync (Firebase)
- Social features (share progress)
- Book recommendations
- Advanced animations
- Bookmark highlights
- Multiple languages
- Custom avatar creation

---

## 🛡️ Privacy & Offline

- **100% Offline**: No cloud required
- **No Tracking**: Reading data stays on device
- **No Ads**: Pure reading experience
- **Open Source Ready**: Transparent code

---

## 📊 Performance Tips

1. **Reduce Avatar Animation Complexity**: Disable Lottie if needed
2. **Optimize Large Books**: Split chapters >50KB
3. **Memory Management**: Use `dispose()` properly
4. **Battery Saving**: Reduce TTS quality on low battery

---

## 🐛 Troubleshooting

### TTS Not Working
- Check Flutter TTS plugin initialization
- Verify device has TTS engine installed
- Try different voice types in settings

### App Crashes on Import
- Ensure file path is valid
- Check file format (EPUB/TXT/PDF)
- Verify app has file permission

### Avatar Voice Sounds Wrong
- Adjust pitch/speed in reader
- Try different avatar
- Check device language settings

---

## 📄 License

[Your License Here]

---

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repo
2. Create a feature branch
3. Submit a pull request

---

## 📞 Support

For issues, feature requests, or feedback:
- Open a GitHub issue
- Email: support@storyteller-app.com

---

## ❤️ Made with addiction to beautiful design & compelling UX

The goal: Make reading **irresistible**.

**Read more. Feel more. Experience stories like never before.**
