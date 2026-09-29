Tasky

A simple and clean to-do app built with Flutter. Tasks, user info, profile picture and theme are stored locally using Hive, so everything is still there when you reopen the app.

Features
Splash screen and onboarding (Welcome screen with name validation)
Home screen with greeting, progress indicator (e.g. 3 out of 6 = 50%) and high priority tasks
Add, edit, delete and check/uncheck tasks (completed tasks appear with a strikethrough)
Show / hide completed tasks
To Do and Completed screens
Profile screen: change profile picture (file picker), edit name and motivation quote, log out
Light and Dark mode, saved locally
Bottom navigation bar
Tech Stack
Purpose	Package
Local storage	hive, hive_flutter
Fonts	google_fonts (Poppins)
Profile image	file_picker
Project Structure
lib/
├── main.dart
├── core/          # app theme (light & dark)
├── models/        # Task model
├── services/      # Hive storage service
├── widgets/       # reusable widgets (button, task tile, avatar)
└── screens/       # splash, welcome, home, tasks list,
                   # new task, profile, user details
Getting Started
bash
git clone https://github.com/MeeladSam/Tasky.git
cd Tasky
flutter pub get
flutter run

Requires Flutter 3.x and an Android emulator / device (or iOS simulator).

Notes
Data is stored locally on the device, so a new user starts with an empty app.
To test the profile picture on an emulator, drag an image onto the emulator screen first.
Author

Melad Sam
