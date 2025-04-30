# 🏴‍☠️ Banana Bay Pirates

**Banana Bay Pirates** is a mobile endless runner game built with **Flutter**, where players sail the high seas, dodge deadly obstacles, and collect golden bananas to beat their high scores! Compete as a guest or sign in with Google to climb the leaderboard. Arrr you ready?

![Banana Bay Pirates Gameplay Banner](banner-placeholder.png) <!-- Add your image path here -->

## 🚀 Features

- 🌊 **Endless Runner Mechanics** – Play endlessly with increasing difficulty
- 🏆 **Score Tracking** – Compete against your own scores or as a guest
- 🔐 **Firebase Authentication** – Login via Google or continue as a guest
- 📊 **Leaderboard (Coming Soon)** – Global leaderboard to show top pirates
- 💥 **Obstacles and Power-Ups** – Navigate cannonballs, whirlpools, and more!
- 🎮 **Smooth Controls** – Swipe and tap your way through the open sea

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

## 📂 Project Structure

```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── game_screen.dart
│   └── leaderboard_screen.dart
├── widgets/
│   └── pirate_controls.dart
├── services/
│   └── firebase_auth_service.dart
├── models/
│   └── player_score.dart
```

## 💡 Roadmap

- [x] Add Firebase Authentication (Google + Guest)
- [x] Implement endless runner logic
- [ ] Add pirate-themed music and sound effects
- [ ] Global leaderboard integration
- [ ] Skins and customizations for your pirate ship
- [ ] Multiplayer challenge mode

## 🏴‍☠️ Meet the Crew

**Rebecca L. Smith**  
🎓 Computer Science Major at Cal Poly Pomona  
🎮 Passionate about mobile games, UI/UX, and bringing ideas to life through code  

[![LinkedIn](https://img.shields.io/badge/Rebecca_LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/in/rebeccalsmithdev)

## 🤝 Contributions

Want to contribute a pirate skin or help with gameplay improvements? Pull requests are welcome! For major changes, please open an issue first to discuss your ideas.

## 📜 License

This project is licensed under the [MIT License](LICENSE).
