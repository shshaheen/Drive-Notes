# 📓 Drive Notes

Drive Notes is a Flutter app that lets users create, edit, and manage text notes stored directly in their **Google Drive**. Built with clean architecture using **Riverpod**, **GoRouter**, **Hive (offline support)**, and **Google Drive API**.

---

## 🚀 How to Run the App

### 1. 📆 Clone the Repository
```bash
git clone https://github.com/shshaheen/Drive-Notes.git
cd drive_notes
```

### 2. 🔧 Install Dependencies
```bash
flutter pub get
```

### 3. 🔐 Google API Setup

#### Google Cloud Console Setup for Android

This guide explains how to set up Google Cloud Console for your Android app, including enabling necessary APIs, configuring OAuth, and adding test users.

---

#### ✅ Step 1: Open Google Cloud Console

1. Visit [Google Cloud Console](https://console.cloud.google.com/)
2. Sign in using your Google account

---

#### ✅ Step 2: Create a New Project

1. Click the project dropdown at the top
2. Select **New Project**
3. Fill in:
   - Project name: e.g., `DriveNotes`
   - Organization: *(optional or "No organization")*
4. Click **Create**

---

#### ✅ Step 3: Enable Required APIs

1. Navigate to **APIs & Services > Library**
2. Enable the following:
   - Google Drive API
   - Google People API
3. Click **Enable** on each

---

#### ✅ Step 4: Configure OAuth Consent Screen

1. Go to **APIs & Services > OAuth consent screen**
2. Choose **External** > Click **Create**
3. Fill out:
   - App name: e.g., `DriveNotes`
   - User Support Email
   - Developer contact email
4. Click **Save and Continue** until done

---

#### ✅ Step 5: Create OAuth 2.0 Client ID for Android

1. Go to **Credentials**
2. Click **Create Credentials > OAuth client ID**
3. Select **Android**
4. Fill in:
   - **Package name**: e.g., `com.example.drive_notes`
   - **SHA-1 fingerprint**: Run below command to get it:

   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

---

#### ✅ Step 6: Add Test Users (For OAuth)

1. Go back to **OAuth consent screen**
2. Scroll to **Test users**
3. Click **Add Users**
4. Add Gmail addresses you’ll use for testing
5. Click **Save**

---

### 4. 📱 Launch the App
```bash
flutter run
```

---

## ✨ Features

- 🔐 Google Sign-In (OAuth2)
- 📝 Create/Edit Notes saved as `.txt` files in Google Drive
- 📁 All notes stored inside a dedicated `DriveNotes` folder
- 🌐 Sync with Google Drive (read/write/delete)
- 📡 Offline Support in Main Screen via Hive
- ⚙️ Clean Architecture using Riverpod, GoRouter

---

## ❗ Known Limitations

- ⚠️ Offline Limitations:

Only the Main Screen (list of notes) is accessible offline

Create, edit, and delete operations are disabled offline

Offline files are only visible if previously loaded when online

- 🔐 Google API Restrictions:

App only works for test users added in Google Cloud Console

Public users cannot access the app unless verified and published

---

## 📂 Folder Structure

```
lib/
│
├── models/                  # Data models (e.g., NoteFile)
│
├── providers/              # Riverpod providers for auth and file state
│   ├── auth_state_provider.dart
│   ├── file_state_notifier.dart
│   └── google_auth_provider.dart
│
├── screens/                # UI screens
│   ├── create_note_screen.dart
│   ├── edit_note_screen.dart
│   ├── welcome_screen.dart
│   └── widgets/
│       └── note_tile.dart
│
├── services/               # Google API and Drive logic
│   ├── google_auth_service.dart
│   └── drive_service.dart
│
└── main.dart               # Entry point
```

---

## 💪 Testing

Run widget tests with:
```bash
flutter test
```

✅ Example tested: `NoteTile` Widget

