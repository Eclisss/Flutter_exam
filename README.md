# Flutter FakeAPI Persons App

## Overview
This Flutter application retrieves persons from FakeAPI ([https://fakerapi.it/en](https://fakerapi.it/en)) and displays them in a list or table. The app supports infinite scrolling, pull-to-refresh, and a detailed view for each person.

## Supported Platforms
- Android
- iOS
- Web

## Features
### Fetching Data
- Fetches **20 persons per request**.
- **Initial Load:** Retrieves the first **10 persons**.
- **Infinite Scrolling:** Loads more persons when scrolling down.
- **No More Data Message:** After **4 attempts**, a message is displayed to prevent further loading.
- **Pull-to-Refresh (Mobile)** / **Refresh Button (Web):** Clears the list and reloads the first page.

### Displaying Data
Each person entry includes:
- **Name**
- **Email**
- **Image (Replaced with an icon)**

### Detail View
- When an item is selected, a new screen displays all available information about the person.

## Running the Application
### Prerequisites
- Install **Flutter**: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- Ensure **Android Studio** or **Xcode** is set up for running Flutter apps.
- Install dependencies:
  ```sh
  flutter pub get
  ```

### Running on Emulator/Device
To run the app on Android, iOS, or Web:
```sh
flutter run
```

For Web:
```sh
flutter run -d chrome
```

## Notes for Reviewer
### Why Icons Instead of API Images?
FakeAPI's image URLs are unreliable and may break unexpectedly. To ensure a **consistent UI experience**, we opted for an **account icon** in place of images. This improves performance and prevents broken image links.

---
Developed with ❤️ using Flutter by Mary Margarette Mariano

