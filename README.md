# AuthCrypt: AES Encrypted Security in Password Management

# Features
- One master password
- Biometrics for password viewing enabling two-layer security
- Random password generation feature
- AES Encrypted Security in Password Management
- Dark and Light Theme mode
- Saves user data to local Storage
- Search Password feature
- Password Strength Meter


# Documentation and Code Quality

We strive to maintain a high standard of documentation, code readability, and adherence to best practices in our project. Here's an overview of key aspects:

## Comments and Documentation

- **Code Comments:** Our codebase is thoroughly commented to enhance readability and understanding. Each module, function, and critical section includes comments explaining the logic and purpose.
  
- **README File:** This README serves as comprehensive documentation, providing insights into the project's features, structure, and dependencies. Screenshots are included for visual clarity.

## Code Quality

- **Adherence to Best Practices:** We follow industry best practices to ensure clean, efficient, and maintainable code. Our coding standards adhere to guidelines recommended by the Flutter community.

- **Modularity:** The project is organized into modular components, promoting a clear separation of concerns. Each module focuses on specific functionality, making it easier to maintain and extend.

- **Coding Conventions:** We maintain a consistent coding style throughout the project, making use of descriptive variable and function names. This ensures that our codebase is both easy to read and understand.

We welcome feedback and suggestions for improvement, as we are committed to continuous enhancement and delivering a high-quality software product.

# Packages we are using:
- shared_preferences: [link](https://pub.dev/packages/shared_preferences)
- persistent_bottom_nav_bar: [link](https://pub.dev/packages/persistent_bottom_nav_bar)
- provider: [link](https://pub.dev/packages/provider)
- sqflite: [link](https://pub.dev/packages/sqflite)
- cached_network_image: [link](https://pub.dev/packages/cached_network_image)
- favicon: [link](https://pub.dev/packages/favicon)
- intl: [link](https://pub.dev/packages/intl)
- path: [link](https://pub.dev/packages/path)
- flutter_svg: [link](https://pub.dev/packages/flutter_svg)
- webview: [link](https://pub.dev/packages/webview_flutter)
- form_field_validator: [link](https://pub.dev/packages/form_field_validator)

 

# Screenshots
**Saved Passwords**
![Saved Passwords](screenshots/savedPasswords.jpg)
**Master Password**
![Master Password](screenshots/masterPassword.jpg)
**Change Master Password**
![Change Master Password](screenshots/changeMasterPassword.jpg)
**Password Generator**
![Password Generator](screenshots/passwordGenerator2.jpg)

# Project Structure 

The project is organized into various directories to maintain a clean and modular codebase. Here is an overview of the directory structure:

```plaintext
/authcrypt
└── lib
    ├── consts
    ├── main.dart
    ├── models
    │   └── addPasswordModel.dart
    ├── provider
    │   ├── addPasswordProvider.dart
    │   ├── generatedPasswordProvider.dart
    │   └── themeProvider.dart
    ├── screens
    │   ├── authentication
    │   │   ├── login.dart
    │   │   └── register.dart
    │   ├── onBoardingPage.dart
    │   ├── settings
    │   │   ├── changePassword.dart
    │   │   └── settings.dart
    │   ├── homepage.dart
    │   ├── passwordGeneratorPage.dart
    │   └── vault
    │       ├── addPassword.dart
    │       ├── vaultpage.dart
    │       └── viewPassword.dart
    ├── services
            ├── databaseService.dart
    │       ├── themePreferences.dart
    ├── utils
    └── widgets
            ├── customButton.dart
            ├── customSearchField.dart 








