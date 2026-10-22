# recipe_book

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Recipe Book (Flutter + SQLite)

A mobile application that manages structured data with a database. Users can browse, search, add, edit and delete recipes. The app is useful for beginners who do not know how to cook: they pick a meal type, choose Veg or Non-veg, and follow simple numbered steps.

Built as a Flutter UI Design lab mini-project (Experiment 13).

## Aim

Build a mobile application that allows users to manage structured data with a database. The application has an intuitive user interface designed with Flutter's core widgets (Form, TextFormField, DropdownButton, ListView, etc.) and demonstrates how to read, display, update and remove data using database operations.

## Features

- **Create:** add your own recipe using a form (name, cooking time, Veg/Non-veg, meal type, difficulty, ingredients, steps)
- **Read:** recipe list and a detail page with ingredients and numbered steps
- **Update:** edit any recipe (pencil icon)
- **Delete:** swipe a card left or use the trash icon on the detail page (your own recipes only)
- **Built-in recipes:** about 28 ready-made recipes; they are locked and cannot be deleted
- **Meal sections:** Breakfast, Lunch/Meals, Snacks, Drinks & Juices, Dessert
- **Diet filter:** Veg / Non-veg, separate from the meal type
- **Difficulty filter:** Easy, Medium, Hard
- **Search** by recipe name or ingredient
- **Favorites:** tap the heart, and filter to show favorites only
- Works on Android phones and on Windows desktop

## Tech stack

- Flutter and Dart
- SQLite through the `sqflite` package (`sqflite_common_ffi` for Windows/Linux desktop)
- `path` and `path_provider` for the database location

## Widgets used

`Form`, `TextFormField`, `DropdownButtonFormField`, `DropdownButton`, `ListView`, `ChoiceChip`, `Card`, `ListTile`, `Dismissible`, `AlertDialog`, `FloatingActionButton`, `SnackBar`

## Project structure

```
lib/
├── main.dart                  App entry point and theme
├── home_screen.dart           Recipe list, search and filters      (frontend)
├── recipe_form_screen.dart    Add / edit form                      (frontend)
├── recipe_detail_screen.dart  Single recipe view                   (frontend)
├── recipe.dart                Recipe model, meal types, icons      (data)
├── database_helper.dart       SQLite create, read, update, delete  (backend)
├── seed_recipes.dart          First 15 built-in recipes            (data)
└── more_recipes.dart          Extra built-in recipes               (data)
```

## How to run

1. Install Flutter and Android Studio (with an emulator), or connect an Android phone with USB debugging.
2. Clone the repository:
   ```
   git clone https://github.com/afifa-31/recipe-book-flutter.git
   cd recipe-book-flutter
   ```
3. Get the packages:
   ```
   flutter pub get
   ```
4. Check your devices and run:
   ```
   flutter devices
   flutter run -d <device-id>
   ```
   For the Windows desktop version, use `flutter run -d windows`.

## Install on an Android phone

Download `app-release.apk` from the **Releases** page of this repository, open it on your phone and allow installation from unknown sources.

## Notes

- The database is stored on each device. Recipes added on one device are not shared with other devices.
- Chrome (web) is not supported because the app uses `dart:io` and local SQLite.

## Future scope

- Online recipe sharing between users using Firebase
- User login so each person can edit only their own recipes
- Recipe photos and a shopping list

## Team Members
Afifa Afsar - 24501A4203
B.Kavyanjali - 24501A4209
D.Poojitha - 24501A4215
Shaik Farhana - 24501A4250
