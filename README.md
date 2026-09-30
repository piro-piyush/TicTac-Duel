# 🎮 Tic Tac Duel

> A futuristic neon Tic Tac Toe game built with Flutter.

<div style="text-align: center;">
  <img
    src="./assets/screens/header_new.png"
    alt="Tic Tac Duel — Your Move. Your Glory."
    width="1280"
  />
</div>

---
## 📱 About

**Tic Tac Duel** is a futuristic Tic Tac Toe game built with Flutter, designed around a clean, competitive, and neon-themed gameplay experience.

The game focuses on **local gameplay**, allowing players to enjoy Tic Tac Toe without requiring an internet connection, online account, multiplayer server, or external API.

Players can choose between:

* 👥 **Friend Mode** — Play against a friend on the same device.
* 🤖 **CPU Mode** — Challenge the computer with selectable difficulty levels.

The game also supports configurable rounds, multiple visual themes, background music, sound effects, animations, local avatars, and a responsive mobile interface.

---

## ✨ Features

### 🎮 Gameplay

* 🎯 Classic 3×3 Tic Tac Toe gameplay
* 👥 Local two-player pass-and-play
* 🤖 CPU opponent mode with multiple difficulty levels
* 🏆 Multi-round matches (3, 5, or 7 rounds)
* 🥇 Match score tracking and round results
* 🤝 Draw detection
* 🔄 Smooth replay and new-round flow
* 🚪 Quit-game confirmation dialogs

### 🎨 Customization & Visuals

* 🌌 Futuristic neon cyberpunk interface
* 🎭 Multiple visual game themes
* 🧑‍🎨 Local SVG avatar selection system
* ✨ Neon glow and ambient lighting effects
* 🌠 Animated particle backgrounds
* 💫 Interactive tap ripple feedback
* 📱 Fully responsive mobile UI layout

### 🔊 Audio & Animation

* 🎵 Background music (BGM)
* 🔊 Interactive sound effects (SFX)
* 🎉 Confetti victory celebrations
* 🎬 Lottie animations for game states
* ⚡ Animated gameplay feedback

### 📖 User Experience

* 🏠 Home navigation menu
* ⚙️ Custom settings screen
* ❓ Rules & Help screen
* 🏆 Win, Lose, and Draw result overlays
* 🌙 Dark mode aesthetic optimized for OLED displays

---

## 🖼️ Screenshots

### 🏠 Main Navigation

|                Home                |                  Settings                  |                Help                |
|:----------------------------------:|:------------------------------------------:|:----------------------------------:|
| ![Home](./assets/screens/home.png) | ![Settings](./assets/screens/settings.png) | ![Help](./assets/screens/help.png) |

### 🕹️ Game Setup Modes

|                Friend Mode Setup                 |               CPU Mode Setup               |
|:------------------------------------------------:|:------------------------------------------:|
| ![Friend Mode](./assets/screens/friend_mode.png) | ![CPU Mode](./assets/screens/cpu_mode.png) |

### 🎮 Active Gameplay Boards

|                         Friend Game Board                         |                       CPU Game Board                        |
|:-----------------------------------------------------------------:|:-----------------------------------------------------------:|
| ![Friend Game Board](./assets/screens/game_board_with_friend.png) | ![CPU Game Board](./assets/screens/game_board_with_cpu.png) |

### 🏆 Match Results

|               Win Result                |                Lose Result                |                Draw Result                |
|:---------------------------------------:|:-----------------------------------------:|:-----------------------------------------:|
| ![Win Result](./assets/screens/win.png) | ![Lose Result](./assets/screens/lose.png) | ![Draw Result](./assets/screens/draw.png) |

---

## 🕹️ Game Modes & Rules

### 👥 Friend Mode

Play Tic Tac Toe locally with a friend on a single device. Players take turns placing their designated symbol on the 3×3 grid until a player achieves 3 symbols in a row or the grid fills up.

### 🤖 CPU Mode

Challenge the computer locally across multiple AI difficulty modes ranging from casual to strategic precision. No network connection is needed.

### 🏆 Multi-Round Matches

Set custom match lengths before starting:

* **3 Rounds** (Best of 3)
* **5 Rounds** (Best of 5)
* **7 Rounds** (Tournament Style)

The player with the highest score after all configured rounds are completed takes the match victory!

---

## 🛠️ Tech Stack

### Core

* **Framework:** Flutter `3.47.2`
* **Language:** Dart `3.13.2`
* **State Management & Navigation:** GetX
* **Local Storage:** Flutter Secure Storage
* **Audio:** `just_audio`
* **Animations:** Lottie & Flutter Confetti
* **Vector Graphics:** `flutter_svg`

### Key Dependencies

| Package            | Purpose                            |
|--------------------|------------------------------------|
| `get`              | State management and navigation    |
| `flutter_svg`      | SVG avatar rendering               |
| `lottie`           | Game animations                    |
| `just_audio`       | Background music and sound effects |
| `flutter_confetti` | Victory celebrations               |

### Development Tools

* **`flutter_lints`** — Dart and Flutter linting
* **`flutter_native_splash`** — Native splash screen
* **`icons_launcher`** — App icon generation
* **`change_app_package_name`** — Package name configuration

---

## 📁 Project Structure & Assets

### 📂 Project Structure

```text
lib/
├── bindings/           # GetX dependency injection
├── constants/          # App constants, routes, themes & configuration
├── controller/         # GetX controllers and game state
├── models/             # Game, player and result models
├── screens/            # App screens and screen-specific widgets
│   ├── game/
│   ├── game_board/
│   ├── help/
│   ├── home/
│   ├── result/
│   └── settings/
├── services/           # Local storage and app services
├── utils/              # Game logic and utility helpers
├── widgets/            # Reusable UI components, effects & painters
├── lib.dart            # Central library exports
└── main.dart           # Application entry point

assets/
├── animations/         # Lottie animations
├── app/                # App icon and splash assets
├── audio/              # Background music and sound effects
├── avatars/            # Local player avatars
├── logo/               # App logo
└── screens/            # README screenshots

```

---

## 🚀 Getting Started

### Prerequisites

Make sure your environment meets the minimum version requirements:

```bash
flutter doctor

```

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/piro-piyush/tictac-duel.git
   cd tictac-duel
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run static code analysis:**
   ```bash
   flutter analyze
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```

---

## 📦 Releases & Android Builds

Tic Tac Duel is automatically built and released through GitHub Actions when manually triggered via `workflow_dispatch`.

Every successful release build generates:

* **ARM64 APK** — Recommended for most modern Android phones
* **ARMv7 APK** — For older 32-bit Android devices
* **x86_64 APK** — Mainly for Android emulators and x86 devices
* **AAB** — Android App Bundle for Google Play distribution

### 📥 Download

* **Latest Release:** [https://github.com/piro-piyush/tictac-duel/releases/latest](https://github.com/piro-piyush/tictac-duel/releases/latest)
* **All Releases:** [https://github.com/piro-piyush/tictac-duel/releases](https://github.com/piro-piyush/tictac-duel/releases)

### 📱 Which APK Should I Download?

| Build                         | Recommended For                   |
|-------------------------------|-----------------------------------|
| `app-arm64-v8a-release.apk`   | **Most modern Android phones**    |
| `app-armeabi-v7a-release.apk` | Older 32-bit Android devices      |
| `app-x86_64-release.apk`      | Android emulators and x86 devices |
| `app-release.aab`             | Google Play Store distribution    |

> **💡 Recommended:** If you're installing Tic Tac Duel directly on a modern Android phone, download the **ARM64 (`arm64-v8a`) APK**.

### 🔨 Build Locally

If you want to build the application yourself:

```bash
# Standard release APK
flutter build apk --release

# Architecture-specific APKs
flutter build apk --release --split-per-abi

# Google Play App Bundle
flutter build appbundle --release

```

**Split APK output:**

```text
build/app/outputs/flutter-apk/
├── app-arm64-v8a-release.apk
├── app-armeabi-v7a-release.apk
└── app-x86_64-release.apk

```

**AAB output:**

```text
build/app/outputs/bundle/release/app-release.aab

```

### ⚙️ Automated Release

The project uses **GitHub Actions** to automatically:

1. Set up Java 17 and Flutter 3.47.2
2. Restore the Android signing configuration
3. Install project dependencies
4. Run Flutter analysis
5. Build split release APKs
6. Build the Google Play AAB
7. Upload the builds as GitHub Actions artifacts
8. Create a GitHub Release using the target branch and version specified in `pubspec.yaml`
9. Attach the APKs and AAB to the GitHub Release

The workflow can be triggered manually using **GitHub Actions → Build Flutter Android → Run workflow** on any branch.

---

## 🤝 Contributing & Support

Contributions, bug reports, and feature suggestions are welcome.

### Contributing

1. **Fork the repository**

2. **Create a branch from `main`:**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/your-feature-name
   ```

3. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: Add your feature"
   ```

4. **Push your branch:**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **Open a Pull Request** targeting the `main` branch.

### 🌿 Branches

- `main` — Stable development branch
- `feature/*` — New features and improvements
- `fix/*` — Bug fixes
- `release/*` — Release preparation and versioned releases
- `release/v1.0.0` — Release branch for version `1.0.0`

For future releases, use the same release naming convention:

```text
release/v1.1.0
release/v1.2.0
release/v2.0.0
```

---

### 🐛 Bug Reports & Feature Requests

If you find a bug or have an idea for improving Tic Tac Duel, please open an issue on GitHub:

👉 [https://github.com/piro-piyush/tictac-duel/issues](https://github.com/piro-piyush/tictac-duel/issues)

---

## 📄 License

Tic Tac Duel is open-source software licensed under the **MIT License**.

You are free to use, copy, modify, merge, publish, distribute, sublicense, and sell copies of the software, subject to the terms of the license.

See the [`LICENSE`](./LICENSE) file for the complete license text.