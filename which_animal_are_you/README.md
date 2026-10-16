# Which Animal Are You? 🐾

A vibrant, cross-platform Flutter application that captures a selfie or uploads a photo, analyzes facial attributes (simulated with playful algorithms), and reveals the user's animal counterpart.

## Project Structure

```
lib/
├── main.dart
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   ├── constants/
│   │   └── animal_constants.dart
│   └── providers/
│       └── theme_provider.dart
└── features/
    ├── home/
    │   └── presentation/
    │       ├── home_screen.dart
    │       └── brand_logo.dart
    ├── scan/
    │   ├── presentation/
    │   │   └── scan_screen.dart
    │   └── providers/
    │       └── scan_provider.dart
    └── result/
        ├── presentation/
        │   └── result_screen.dart
        └── providers/
            └── result_provider.dart
```

## Tech Stack
- **Flutter 3.47.7**
- **Riverpod** for state management
- **Google Fonts** (Poppins for headlines, Inter for body)
- **image_picker** & **camera** packages for image capture
- **share_plus** for social sharing
- **flutter_svg** for vector assets
- **Shared Preferences** for theme persistence

## Design Highlights
- **Dark Mode**: Deep Charcoal (`#121212`) & Midnight Gray (`#1E1E1E`)
- **Light Mode**: Off-White (`#F8F9FA`) & Soft Cream (`#F8F5F0`)
- **Accent Colors**: Warm Coral (`#FF6F61`), Vibrant Amber (`#FFA000`), Jungle Green (`#2E7D32`)
- Animated scanning overlay with pulsing radar grid
- Dynamic loading messages
- Playful animal emoji illustrations with trait badges
- Social share card preview
- Responsive layout for mobile screens (iOS & Android)

## Running the App

```bash
flutter pub get
flutter run
```

## Features
- Take a selfie or upload from gallery
- Animated analysis screen with cycling messages
- Random animal match with percentage score (65-99%)
- Personality description and trait badges
- One-tap social sharing
- Light/Dark mode toggle
- Robust error handling for camera permissions and image failures
