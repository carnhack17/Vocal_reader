# 🚀 Quick Start Guide - Storyteller App

## Installation (2 minutes)

### Step 1: Setup Flutter Project
```bash
flutter create storyteller_app --org com.storyteller
cd storyteller_app
```

### Step 2: Replace pubspec.yaml
Copy the provided `pubspec.yaml` into your project root.

### Step 3: Install Dependencies
```bash
flutter pub get
```

### Step 4: Copy App Files
Copy all files from `lib/` directory into your project's `lib/` folder:
- `main.dart`
- `core/` (models, services, constants)
- `providers/` (state management)
- `features/` (screens)
- `widgets/` (UI components)

### Step 5: Create Assets Directory
```bash
mkdir -p assets/avatars
mkdir -p assets/fonts
mkdir -p assets/sample_books
```

### Step 6: Run the App
```bash
flutter run
```

---

## 📱 First Time User Flow

### 1. **App Launches**
   - Home screen appears with avatar spotlight
   - See "No Books Yet" empty state
   - Ready to import first book

### 2. **Navigate to Library** (Bottom nav → Library icon)
   - Tap "Import Book" button
   - Select a `.txt`, `.epub`, or `.pdf` file
   - Book appears in library

### 3. **Choose Avatar** (Bottom nav → Avatar icon)
   - See 5 avatars (sample - expand to 20)
   - Tap any avatar to select
   - Avatar becomes your narrator

### 4. **Start Reading** (Back to Home or Library)
   - Tap on book in library
   - Reader screen opens
   - Tap ▶️ Play button
   - Avatar appears at top
   - Text scrolls below
   - TTS narration plays

### 5. **Adjust Voice Settings**
   - Drag Speed slider (0.5x to 2x)
   - Drag Pitch slider (low to high)
   - Next/Previous chapter buttons
   - Play/pause anytime

### 6. **Progress Saved Automatically**
   - Close app
   - Next session: Tap "Continue Reading"
   - Returns to exact position

---

## 🎯 Key UI Elements

### Home Screen (Addictive Design 🧠)
```
┌─────────────────────────┐
│ Welcome Back            │
│ Your stories await...   │
├─────────────────────────┤
│                         │
│   [Avatar Image]        │ ← Hook #1: Beautiful avatar
│     Elyas               │
│   "mysterious"          │
│                         │
├─────────────────────────┤
│ ▶️ Continue Reading      │ ← Hook #2: Frictionless re-entry
│ The Great Gatsby        │
│ by F. Scott Fitzgerald  │
│ ████░░░░ 45%            │
├─────────────────────────┤
│ 🔥 3 days  📚 5 books   │ ← Hook #3: Gamification
│                         │
│ Your Library (horizontal)│
│ [Book] [Book] [Book]    │
└─────────────────────────┘
```

### Reader Screen (Voice + Scroll 📖🗣️)
```
┌─────────────────────────┐
│ The Great Gatsby        │ ← Title
│ Chapter 1/5             │
│ ████░░░░░░ 20%          │ ← Progress
├─────────────────────────┤
│ [Avatar Image]          │ ← Narrator
│ Elyas - Now Narrating   │
├─────────────────────────┤
│ scrollable text...      │
│ "It was a pleasure to   │ ← Synced with voice
│ meet you, looking as    │
│ though you might have    │
│ some initial confused   │
│ idea I was acting out   │
│ the end of that..."     │
│                         │
│ [scroll more...]        │
├─────────────────────────┤
│ < Prev | 1/5 | Next >   │
│ ___Speed: 1.0x ___      │
│ ___Pitch: 1.0 ___       │
│ ▶️ Play Narration       │ ← Main CTA
└─────────────────────────┘
```

---

## ⚙️ Configuration Quick Tips

### Add More Avatars
Edit `lib/core/services/storage_service.dart`:
```dart
List<Avatar> _getDefaultAvatars() {
  return [
    Avatar(
      id: 'elyas',
      name: 'Elyas',
      imagePath: 'assets/avatars/elyas/image.png',
      voiceType: 'en-US-1',
      personality: 'mysterious',
      bestFor: ['fantasy', 'thriller'],
      description: 'A mysterious wanderer with a deep voice',
    ),
    // ADD MORE HERE
  ];
}
```

### Change Colors
Edit `lib/core/constants/theme.dart`:
```dart
class AppColors {
  static const primary = Color(0xFF6B4EFF);    // Purple
  static const secondary = Color(0xFFFF6B9D); // Pink
  static const accent = Color(0xFF4ECDC4);    // Teal
  // Change these to your brand colors
}
```

### Customize Spacing & Radius
```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;  // Modify
  static const lg = 24.0;  // these
  static const xl = 32.0;  // values
}

class AppRadius {
  static const small = 8.0;
  static const medium = 12.0;    // Adjust
  static const large = 16.0;     // border
  static const xl = 24.0;        // radius
}
```

---

## 🎧 Testing Voice Narration

### Test TTS Locally
1. Go to Reader Screen
2. Choose a book
3. Tap ▶️ Play
4. Should hear device's system voice reading

### Debug TTS Issues
- Check in `lib/core/services/tts_service.dart`
- Add print statements:
  ```dart
  void speak(String text) async {
    print('Speaking: $text');
    await _tts.speak(text);
  }
  ```

### Change Voice Type
Edit reader screen and modify:
```dart
await _ttsService.setVoice('en-US-2'); // Try different voices
```

---

## 📊 Sample Book Data

The app includes default sample avatars. To test with real books:

### Option A: Manual Import
1. Create a `.txt` file with book content
2. Open app → Library → Import
3. Select the file

### Option B: Programmatic Sample
Add to `storage_service.dart`:
```dart
Future<void> loadSampleBooks() async {
  final book = Book(
    id: 'sample-1',
    title: 'Sample Story',
    author: 'Demo Author',
    filePath: 'assets/sample_books/story.txt',
    fileType: 'txt',
    genre: 'adventure',
    chapters: ['Chapter 1 text...', 'Chapter 2 text...'],
    dateAdded: DateTime.now(),
  );
  books.add(book);
}
```

---

## 🔧 Build & Deploy

### Android
```bash
flutter build apk --release
# Find APK at: build/app/outputs/flutter-app-release.apk
```

### iOS
```bash
flutter build ios --release
# Use Xcode to deploy to App Store
```

---

## 🎯 Addictive Design Checklist

- ✅ Avatar spotlight (emotional hook)
- ✅ Continue reading (frictionless re-entry)
- ✅ Reading streak (gamification)
- ✅ Progress bars (visual feedback)
- ✅ Chapter celebrations (micro-wins)
- ✅ Voice + scroll (sensory experience)
- ✅ Dark theme (eye-friendly)
- ✅ Smooth transitions (premium feel)

---

## 📝 Next Steps

1. **Add More Avatars**: Expand from 5 to 20
2. **Create Avatar Images**: Design/download character artwork
3. **Add Sample Books**: Include classic literature
4. **Polish Animations**: Add Lottie animations
5. **Implement Cloud Sync**: Firebase integration
6. **Add Social Features**: Share reading progress

---

## 💡 Pro Tips

### For Maximum Addiction:
- Make avatar selection **visual** (big images)
- Show **progress constantly** (percentage, streaks)
- Create **celebration moments** (confetti when finishing)
- Make **re-entry frictionless** (one tap to resume)
- Use **micro-interactions** (smooth animations)

### For Performance:
- Lazy-load large books
- Cache avatar images
- Use `const` constructors everywhere
- Profile with DevTools

### For Polish:
- Add subtle sound effects
- Smooth scroll animations
- Haptic feedback on actions
- Gradient backgrounds

---

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| TTS not working | Install system TTS on emulator/device |
| App crashes on import | Check file permissions in `AndroidManifest.xml` |
| Avatar images missing | Ensure files in `assets/avatars/` |
| Slow performance | Reduce animation complexity, use `flutter build` |
| Storage errors | Check device has >100MB free space |

---

## 🎉 You're Done!

Your addictive audiobook reader is ready. Now:

1. Import your first book
2. Choose your favorite narrator
3. Hit play
4. Get addicted to reading! 📖🎧

**Happy narrating! 🎭**
