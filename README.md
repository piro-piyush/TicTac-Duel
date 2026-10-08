# 🎮 Tic Tac Duel

> **YOUR MOVE. YOUR GLORY.**

A futuristic neon Tic Tac Toe game built with Flutter.

<div align="center">
  <img
    src="./assets/screens/header_new.png"
    alt="Tic Tac Duel — Your Move. Your Glory."
    width="1280"
  />
</div>

---

## 📱 About

Tic Tac Duel is a modern Tic Tac Toe experience featuring a futuristic neon interface, local multiplayer, CPU battles, and real-time online multiplayer.

The game combines classic Tic Tac Toe mechanics with a polished arcade-inspired visual style.

---

## ✨ Features

* 🎮 Classic Tic Tac Toe gameplay
* 👥 Local multiplayer
* 🤖 CPU battles
* ⚡ Multiple CPU difficulty levels
* 🌐 Online multiplayer
* 🏆 Multi-round gameplay
* 📊 Score tracking
* 🎨 Multiple visual themes
* 🎵 Background music and sound effects
* ✨ Neon animations and visual effects
* 📱 Responsive mobile interface
* 🌌 Futuristic cyberpunk-inspired UI

---

## 🎮 Game Modes

### 👥 Friend Mode

Play Tic Tac Toe against another player on the same device.

### 🤖 CPU Mode

Challenge the CPU with different difficulty levels and test your skills.

### 🌐 Online Multiplayer

Create or join a room and play Tic Tac Toe against another player in real time.

---

## 🎨 Themes

Tic Tac Duel includes multiple neon-inspired themes designed to give each game a distinct visual atmosphere.

* 💜 **Classic**
* 🔥 **Inferno**
* 💚 **Cyber**

---

## 🎵 Audio & Effects

The game includes an arcade-inspired audio and visual experience.

* 🎵 Background music
* 🔊 Sound effects
* ✨ Neon animations
* 🌌 Particle effects
* 🎉 Confetti effects
* 👆 Interactive touch effects

---

## 🖼️ Screenshots

<div align="center">

<img src="./assets/screens/home.png" height="320" alt="Home">

<img src="./assets/screens/settings.png" height="320" alt="Settings">

<img src="./assets/screens/help.png" height="320" alt="Help">

<img src="./assets/screens/friend_mode.png" height="320" alt="Friend Mode Setup">

<img src="./assets/screens/cpu_mode.png" height="320" alt="CPU Mode Setup">

<img src="./assets/screens/game_board_with_friend.png" height="320" alt="Friend Game Board">

<img src="./assets/screens/game_board_with_cpu.png" height="320" alt="CPU Game Board">

<img src="./assets/screens/win.png" height="320" alt="Win Result">

<img src="./assets/screens/lose.png" height="320" alt="Lose Result">

<img src="./assets/screens/draw.png" height="320" alt="Draw Result">

</div>

---

## 🛠️ Built With

* **Flutter**
* **Dart**
* **GetX**
* **Socket.IO**
* **Flutter Secure Storage**
* **just_audio**
* **Lottie**
* **Flutter Confetti**

---

## 🚀 Getting Started

### Prerequisites

Make sure Flutter is installed and configured on your system.

Check your Flutter installation:

```bash
flutter doctor
```

### Installation

Clone the repository:

```bash
git clone https://github.com/piro-piyush/TicTac-Duel.git
```

Navigate to the project:

```bash
cd TicTac-Duel
```

Install dependencies:

```bash
flutter pub get
```

---

### ⚙️ Environment Setup

Tic Tac Duel uses environment variables for backend configuration.

Create a `.env` file in the project root:

```env
BASE_URL=YOUR_BASE_URL
```

Replace `YOUR_BASE_URL` with the appropriate backend URL.

> **Note:** The `.env` file contains environment-specific configuration and should not be committed to the repository.

---

### ▶️ Run the Application

```bash
flutter run
```

---

## 🧪 Testing

Before submitting changes, run:

```bash
flutter analyze
```

Run the Flutter test suite:

```bash
flutter test
```

For manual testing, verify the main gameplay flows, including:

* Local multiplayer
* CPU gameplay
* CPU difficulty levels
* Online multiplayer
* Multiple rounds
* Themes
* Audio
* Game results
* Room creation and joining
* Player connection/disconnection
* Real-time gameplay

---

# 🌿 Git Development Workflow

Tic Tac Duel uses a simple Git workflow to keep development, testing, and releases organized.

## 🌳 Branch Structure

| Branch       | Purpose                                                 |
| ------------ | ------------------------------------------------------- |
| `main`       | Stable production-ready code                            |
| `dev`        | Active development and integration                      |
| `feature/*`  | New features                                            |
| `fix/*`      | Bug fixes                                               |
| `chore/*`    | Maintenance, testing, cleanup, and project improvements |
| `refactor/*` | Code restructuring                                      |
| `docs/*`     | Documentation changes                                   |
| `test/*`     | Test-related changes                                    |
| `release/*`  | Release preparation and final QA                        |

---

## 🌱 Creating a Branch

Always start from the latest `dev` branch:

```bash
git switch dev
git pull origin dev
```

Create a branch using the appropriate branch type:

```bash
git switch -c feature/feature-name
```

Example:

```bash
git switch -c feature/game-history
```

Push the branch:

```bash
git push -u origin feature/game-history
```

---

## 🏷️ Branch Naming Convention

Use:

```text
<type>/<short-description>
```

Use lowercase names with hyphens.

### Examples

```text
feature/online-multiplayer
feature/game-history

fix/socket-disconnect
fix/invalid-move

chore/v2.0.0-stabilization

refactor/game-controller

docs/update-readme

test/game-controller
```

Keep branch names:

* Short
* Descriptive
* Lowercase
* Hyphen-separated
* Focused on one purpose

---

## 📝 Commit Convention

Use a clear prefix for commit messages.

```text
feat: add game history
fix: handle player disconnect
chore: update CI workflow
refactor: simplify game controller
docs: update README
test: add game controller tests
build: update dependencies
ci: update GitHub Actions
```

### Common prefixes

| Prefix     | Purpose                  |
| ---------- | ------------------------ |
| `feat`     | New functionality        |
| `fix`      | Bug fix                  |
| `chore`    | Maintenance              |
| `refactor` | Code restructuring       |
| `docs`     | Documentation            |
| `test`     | Tests                    |
| `build`    | Build/dependency changes |
| `ci`       | CI/CD changes            |

---

## 🔀 Pull Requests

After completing your work, push your branch:

```bash
git push
```

Create a Pull Request:

```text
feature/my-feature → dev
```

A Pull Request should include:

* Clear title
* Summary of changes
* Testing performed
* Known issues, if any
* Screenshots or recordings when useful

---

## 🤖 CI Checks

Pull Requests targeting `dev` or `release/*` automatically run the Android CI workflow.

The workflow verifies the project and creates release builds.

Checks include:

* Flutter analysis
* Android APK builds
* Android App Bundle build
* Multiple CPU architectures

Pull Requests should be merged only after the required checks pass.

If CI fails, fix the issue and push another commit to the same branch.

The existing Pull Request will automatically update and run CI again.

---

## 🧹 After Merging a Pull Request

Once a Pull Request has been merged into `dev`, the feature branch can be deleted.

Example:

```text
feature/game-history
        ↓
       dev
```

Clean up the local branch:

```bash
git switch dev
git pull origin dev
git branch -d feature/game-history
git fetch --prune
```

Deleting the branch does **not** delete the merged code.

---

# 🚀 Release Workflow

When development for a version is complete, create a release branch from `dev`.

Example:

```bash
git switch dev
git pull origin dev

git switch -c release/v2.0.0
git push -u origin release/v2.0.0
```

Use the release branch for:

* Final testing
* Bug fixes
* UI verification
* Performance checks
* Release verification
* Final QA

When everything is stable:

```text
release/v2.0.0
       ↓
      PR
       ↓
     main
```

---

## 🏷️ Creating a Release Tag

After the release branch is merged into `main`:

```bash
git switch main
git pull origin main
```

Create the version tag:

```bash
git tag v2.0.0
```

Push the tag:

```bash
git push origin v2.0.0
```

Version tags following:

```text
v*.*.*
```

trigger the release workflow.

---

## 📦 Release Builds

The release workflow generates Android builds for different architectures.

### ARM64

```text
app-arm64-v8a-release.apk
```

Recommended for most modern Android phones and tablets.

### ARM32

```text
app-armeabi-v7a-release.apk
```

For older ARM-based Android devices.

### x86_64

```text
app-x86_64-release.apk
```

For compatible Android emulators and x86_64 devices.

### Android App Bundle

```text
app-release.aab
```

The AAB is intended for Google Play distribution.

Google Play generates optimized APKs for supported devices.

---

# 📦 Release

## v2.0.0

The **v2.0.0** release introduces online multiplayer alongside the existing local and CPU gameplay experience.

### Highlights

* 🌐 Online multiplayer
* 👥 Local multiplayer
* 🤖 CPU battles
* ⚡ Multiple CPU difficulty levels
* 🏆 Multi-round matches
* 📊 Score tracking
* 🎨 Multiple themes
* 🎵 Audio and sound effects
* ✨ Neon animations and effects
* 📱 Responsive mobile UI

**Version:** `2.0.0+1`

---

## 📱 Which APK Should I Download?

| APK                           | Architecture | Recommended For                              |
| ----------------------------- | ------------ | -------------------------------------------- |
| `app-arm64-v8a-release.apk`   | ARM64        | Most modern Android phones and tablets       |
| `app-armeabi-v7a-release.apk` | ARM32        | Older Android devices                        |
| `app-x86_64-release.apk`      | x86_64       | Android emulators and compatible x86 devices |

### ⭐ Most Android Phones

Most modern Android phones use ARM64.

For a modern Android phone or tablet, download:

```text
app-arm64-v8a-release.apk
```

If you're using an Android emulator, check its configured CPU architecture and download the matching APK.

> **Note:** Install only the APK that matches your device's CPU architecture.

---

## 📦 Google Play

For Google Play distribution, use:

```text
app-release.aab
```

Google Play automatically generates optimized APKs for supported devices.

---

## ⬇️ Download

[Download Tic Tac Duel v2.0.0](https://github.com/piro-piyush/TicTac-Duel/releases/tag/v2.0.0)

---

## 👨‍💻 Developer

**Piyush Vishwakarma**

Built with Flutter and a passion for creating clean, modern mobile experiences.

---

## ⭐ Support

If you like the project, consider giving the repository a ⭐ on GitHub.

---

> **Tic Tac Duel — YOUR MOVE. YOUR GLORY.**
