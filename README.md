______________________________________________________________________________
Flutter run key commands.
r Hot reload. 
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).
________________________________________________________________________________
lib/
│── main.dart                # Entry point
│
├── screens/                 # Har screen (page) yahan hogi
│   ├── home_screen.dart
│   ├── login_screen.dart
│   └── profile_screen.dart
│
├── widgets/                 # Reusable choti choti cheezein (buttons, cards, etc.)
│   ├── custom_button.dart
│   └── counter_widget.dart
│
├── services/                # API calls, database, authentication
│   ├── api_service.dart
│   └── auth_service.dart
│
├── models/                  # Data models (User, Product, etc.)
│   ├── user_model.dart
│   └── product_model.dart
│
├── utils/                   # Helper functions, constants, themes
│   ├── app_constants.dart
│   └── app_theme.dart
│
└── routes/                  # Navigation routes
    └── app_routes.dart



📝 Example Flow

main.dart

App start hota hai aur MaterialApp me home: HomeScreen() load hota hai.

screens/home_screen.dart

Yeh ek page hai jahan UI banti hai.

widgets/

Reusable UI components (button, textfield, etc.) yahan.

services/

Agar API hit karni hai (e.g., getUsers(), loginUser()).

models/

JSON ko Dart objects me map karne ke liye.

utils/

Constants (colors, strings) aur themes (dark/light).

routes/

Saare pages ek jagah define, Navigator.pushNamed ke liye.



____________________________________ADB COMMANDS BELLOW__________________________________________________________________

adb shell
run-as com.example.begineer_application
cd files
ls
cp default.realm /sdcard/Download/
exit
____________________________________
this below command use in pc
adb pull /sdcard/Download/default.realm C:\Users\HP\Downloads\
