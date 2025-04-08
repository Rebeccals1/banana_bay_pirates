# 🏴‍☠️ Banana Bay Pirates

**Banana Bay Pirates** is a mobile endless runner game built with **Flutter**, where players explore the shores of Banana Bay to dodge deadly obstacles and beat their high scores! Login as a guest or sign in with Google to climb the leaderboard. Arrr you ready?

<img src="https://github.com/Rebeccals1/banana_bay_pirates/raw/main/assets/images/pirate_logo.png" alt="Banana Bay Pirates Gameplay Banner" width="300"/>


## 🚀 Features

- **Endless Runner Mechanics** – Play endlessly with increasing difficulty
- **Score Tracking** – Compete against your own scores or as a guest
- **Firebase Authentication** – Login via Google or continue as a guest
- **Leaderboard** – Global leaderboard to show top pirates

## 📱 Tech Stack

| Technology     | Description                              |
|----------------|------------------------------------------|
| **Flutter**    | Cross-platform mobile development         |
| **Firebase**   | Authentication, Firestore, Hosting        |
| **Dart**       | Primary language for Flutter              |
| **Google Sign-In** | Secure OAuth2 login for users         |

## 🧭 Installation

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/banana-bay-pirates.git
cd banana-bay-pirates
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run
```

Make sure your emulator or device is connected!

## 🔑 Firebase Setup

Before running the app, set up Firebase for Android and iOS:

- Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- Enable **Authentication** (Google Sign-In & Anonymous)
- Configure Firestore for saving scores and user data

## 💡 Roadmap

- [x] Add Firebase Authentication (Google + Guest)
- [x] Implement endless runner logic
- [x] Global leaderboard integration
- [ ] Add pirate-themed music and sound effects
- [ ] Add Power-Ups

## 📜 License

This project is licensed under the [MIT License](LICENSE).
