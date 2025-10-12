# 👨‍💻 Developer Guide - City Guide App

Welcome to the City Guide development team! This guide will help you set up your development environment and contribute effectively to the project.

## 🎯 Quick Navigation

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)

---

## 🚀 Getting Started

### 1. Fork the Repository

Click the **Fork** button at the top right of the repository page. This creates your own copy of the project.

### 2. Clone Your Fork

```bash
# Clone your forked repository
git clone https://github.com/YOUR_USERNAME/Citiguide_App.git

# Navigate to the project
cd cityguide_app

# Add the original repository as upstream
git remote add upstream https://github.com/Philip_Gbesan/Citiguide_App.git
```

### 3. Set Up Development Environment

#### Install Flutter & Dart

```bash
# Verify Flutter installation
flutter doctor

# If issues are found, follow the suggestions
```

#### Install Dependencies

```bash
# Get all project dependencies
flutter pub get

# Generate necessary files (if using code generation)
flutter pub run build_runner build
```

#### Configure Android Studio

1. Open Android Studio
2. Go to **File > Open** and select the project
3. Wait for Gradle sync to complete
4. Connect a device or start an emulator
5. Run the app using the play button or `flutter run`

### 4. Verify Setup

```bash
# Run tests to ensure everything works
flutter test

# Run the app
flutter run
```

---

## 🔄 Development Workflow

### Step 1: Sync Your Fork

Always start with the latest code:

```bash
# Fetch updates from upstream
git fetch upstream

# Switch to main branch
git checkout main

# Merge upstream changes
git merge upstream/main

# Push updates to your fork
git push origin main
```

### Step 2: Create a Feature Branch

```bash
# Create and switch to a new branch
git checkout -b feature/your-feature-name

# Examples:
git checkout -b feature/add-favorite-attractions
git checkout -b bugfix/fix-login-error
git checkout -b enhancement/improve-map-performance
```

**Branch Naming Convention:**
- `feature/` - New features
- `bugfix/` - Bug fixes
- `enhancement/` - Improvements to existing features
- `docs/` - Documentation changes
- `refactor/` - Code refactoring

### Step 3: Make Your Changes

Write clean, well-documented code following our standards (see below).

```bash
# Check your changes
git status

# Add files to staging
git add .

# Commit with a meaningful message
git commit -m "feat: Add favorite attractions feature"
```

**Commit Message Convention:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

### Step 4: Push Your Branch

```bash
# Push to your fork
git push origin feature/your-feature-name
```

---

## 📝 Code Standards

### Dart/Flutter Best Practices

#### 1. Code Formatting

```bash
# Auto-format your code
flutter format .

# Analyze code for issues
flutter analyze
```

#### 2. Naming Conventions

```dart
// Classes: PascalCase
class CityGuideService {}

// Variables & functions: camelCase
void fetchAttractions() {}
String cityName = "Lagos";

// Constants: lowerCamelCase or SCREAMING_SNAKE_CASE
const double defaultRadius = 5.0;
const String API_BASE_URL = "https://api.example.com";

// Private members: prefix with underscore
String _privateVariable;
void _privateMethod() {}
```

#### 3. Widget Structure

```dart
class AttractionCard extends StatelessWidget {
  // 1. Constructor parameters
  final String title;
  final String imageUrl;
  final double rating;

  // 2. Constructor
  const AttractionCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.rating,
  }) : super(key: key);

  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Widget tree
        ],
      ),
    );
  }

  // 4. Private helper methods
  Widget _buildRatingStars() {
    // Implementation
  }
}
```

#### 4. Documentation

```dart
/// Fetches attractions for a specific city.
///
/// Returns a list of [Attraction] objects for the given [cityId].
/// Throws [NetworkException] if the request fails.
///
/// Example:
/// ```dart
/// final attractions = await fetchAttractions('lagos');
/// ```
Future<List<Attraction>> fetchAttractions(String cityId) async {
  // Implementation
}
```

### Project-Specific Guidelines

#### File Organization

- One widget per file (for complex widgets)
- Group related files in folders
- Use barrel exports (`index.dart`) for cleaner imports

#### State Management

```dart
// Use stateful widgets when needed
class AttractionListScreen extends StatefulWidget {
  @override
  _AttractionListScreenState createState() => _AttractionListScreenState();
}

// Consider using Provider, Riverpod, or BLoC for complex state
```

#### Error Handling

```dart
try {
  final attractions = await api.fetchAttractions();
  setState(() => _attractions = attractions);
} catch (e) {
  // Show user-friendly error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Failed to load attractions')),
  );
  // Log error for debugging
  debugPrint('Error fetching attractions: $e');
}
```

---

## 🧪 Testing

### Write Tests for Your Code

```dart
// test/widgets/attraction_card_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AttractionCard displays title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AttractionCard(
          title: 'Test Attraction',
          imageUrl: 'test.jpg',
          rating: 4.5,
        ),
      ),
    );

    expect(find.text('Test Attraction'), findsOneWidget);
  });
}
```

### Run Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widgets/attraction_card_test.dart

# Run with coverage
flutter test --coverage
```

---

## 📤 Submitting Changes

### Step 1: Create an Issue

Before submitting a PR, create an issue describing your work:

**Issue Template:**

```markdown
## 🐛 Bug Report / 💡 Feature Request

### Description
Brief description of the bug or feature

### Current Behavior
What currently happens (for bugs)

### Expected Behavior
What should happen

### Steps to Reproduce (for bugs)
1. Go to '...'
2. Click on '...'
3. See error

### Screenshots
If applicable, add screenshots

### Environment
- Device: [e.g., Pixel 5]
- OS: [e.g., Android 12]
- App Version: [e.g., 1.0.0]

### Proposed Solution (optional)
How you plan to fix/implement this
```

### Step 2: Create a Pull Request

1. Go to your fork on GitHub
2. Click **Compare & pull request**
3. Fill out the PR template:

**PR Template:**

```markdown
## 📋 Description

Brief description of changes

## 🔗 Related Issue

Closes #[issue_number]

## 🎯 Type of Change

- [ ] 🐛 Bug fix
- [ ] ✨ New feature
- [ ] 💄 UI/Style update
- [ ] ♻️ Code refactoring
- [ ] 📝 Documentation update
- [ ] 🧪 Test update

## 🧪 Testing

Describe the tests you ran and how to reproduce:

- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Manual testing completed
- [ ] Tested on Android
- [ ] Tested on iOS (if applicable)

## 📸 Screenshots (if applicable)

Add screenshots of UI changes

## ✅ Checklist

- [ ] My code follows the project's style guidelines
- [ ] I have commented my code where necessary
- [ ] I have updated documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] All tests pass locally
```

### Step 3: Code Review Process

1. **Automated Checks**: CI/CD will run tests automatically
2. **Peer Review**: Team members will review your code
3. **Address Feedback**: Make requested changes if needed
4. **Approval**: Once approved, your PR will be merged

### Step 4: After Merge

```bash
# Switch to main branch
git checkout main

# Pull the latest changes
git pull upstream main

# Delete your feature branch
git branch -d feature/your-feature-name
git push origin --delete feature/your-feature-name
```

---

## 🏗️ Project Architecture

### Folder Structure Explained

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # App configuration
│
├── models/                   # Data models
│   ├── attraction.dart
│   ├── user.dart
│   └── city.dart
│
├── screens/                  # Full-page screens
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   ├── attraction/
│   │   ├── attraction_detail_screen.dart
│   │   └── attraction_list_screen.dart
│   └── auth/
│       ├── login_screen.dart
│       └── register_screen.dart
│
├── widgets/                  # Reusable widgets
│   ├── attraction_card.dart
│   ├── custom_button.dart
│   └── rating_stars.dart
│
├── services/                 # Business logic
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── database_service.dart
│
├── utils/                    # Helper functions
│   ├── constants.dart
│   ├── validators.dart
│   └── theme.dart
│
└── providers/                # State management
    ├── user_provider.dart
    └── attractions_provider.dart
```

---

## 🐛 Common Issues & Solutions

### Issue: Flutter Doctor Errors

```bash
# Run flutter doctor
flutter doctor -v

# Fix Android licenses
flutter doctor --android-licenses
```

### Issue: Build Failures

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter run
```

### Issue: Hot Reload Not Working

```bash
# Stop the app
# Run with hot reload enabled
flutter run --hot
```

---

## 📚 Resources

### Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

### Community

- [Flutter Discord](https://discord.gg/flutter)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)
- [r/FlutterDev](https://www.reddit.com/r/FlutterDev/)

---

## 💬 Getting Help

Stuck? Here's how to get help:

1. **Check Documentation**: Review this guide and project README
2. **Search Issues**: Someone might have had the same problem
3. **Ask Questions**: Create a new issue with the `question` label
4. **Contact Team**: Reach out to the eProjects Team

---

## 🎉 Thank You!

Your contributions make this project better for everyone. Happy coding! 🚀

---

