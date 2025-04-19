# Health Tracker: Smart Recipe and Meal Planning System

A comprehensive Flutter application for managing daily diet, discovering recipes, setting health goals, and planning meals.

## 📋 Project Overview

Health Tracker is a smart recipe and meal planning system designed to help users maintain a healthy lifestyle. The application provides tools for:

- Tracking daily food intake
- Setting and tracking health goals
- Discovering recipes based on preferences and allergies
- Creating meal plans
- Analyzing nutritional intake

## 🚀 Features

### Implemented Features
- ✅ Basic food data models
- ✅ Recipe data models
- ✅ Food searching capability
- ✅ Meal tracking for the last 7 days
- ✅ Favorites management
- ✅ Basic UI theme support

### Planned Features
- 🔄 User registration and profile management
- 🔄 User's allergies tracking
- 🔄 Goal setting and tracking
- 🔄 Daily nutritional intake calculation and display
- 🔄 Meal planning interface
- 🔄 Recipe search by various criteria
- 🔄 Detailed recipe viewing
- 🔄 Progress tracking toward goals
- 🔄 Admin functionality
- 🔄 Recipe recommendations based on dietary preferences

## 🏗️ Architecture

The application follows a clean architecture approach with:

- **Data Layer**: Models, repositories, and data sources
- **Domain Layer**: Business logic and use cases
- **Presentation Layer**: UI components and state management

### State Management
- Provider for general state management
- MobX for reactive state management

### Local Storage
- Hive for efficient local data storage

## 🛠️ Project Setup

### Prerequisites
- Flutter SDK ^3.7.0
- Dart SDK ^3.0.0

### Installation

1. Clone the repository
```bash
git clone https://github.com/osmandemiroz/health_tracker.git
```

2. Navigate to the project directory
```bash
cd health_tracker
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the code generator to create .g.dart files
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. Run the app
```bash
flutter run
```

## 📱 UI Design

The app follows Apple's Human Interface Guidelines with:
- Clean, minimalist design
- Intuitive navigation
- Modern animations
- Consistent visual hierarchy
- Light and dark mode support

## 📊 Database Schema

Based on the Entity-Relationship diagram:
- **User Entity**: Personal information, preferences, allergies
- **Goal Entity**: Health goals with nutritional targets
- **Recipe Entity**: Recipe details and nutritional information
- **Meal Plan Entity**: Daily and weekly meal plans

## 🧪 Testing

- Unit tests for core functionality
- Integration tests for key user flows
- UI tests for critical screens

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📚 Documentation

For comprehensive documentation, see the PRD document: [HEALTH_TRACKER_PRD.md](./HEALTH_TRACKER_PRD.md)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.




## 🛠 Backend Integration:

In this project, we developed a backend running on localhost using Node.js and Express! 🖥️📡 
Thus, managing data has become more scalable and flexible.
## 🔥 FatSecret API Integration:

Users can instantly pull nutritional values without having to enter food information manually! 🛒✨## 🔥 FatSecret API Integration:

Users can instantly pull nutritional values without having to enter food information manually! 🛒✨

## 🏗 Technologies we use:

- ✅ **Flutter** (UI & State Management)
- ✅ **Provider**, **MobX** (State Management)
- ✅ **Hive** (Local Database)
- ✅ **Dependency Injection** (Modular Structure)
- ✅ **Node.js & Express** (Backend API)
- ✅ **FatSecret API** (Feed Data)
- ✅ **Git & GitHub**## 🏗 Technologies we use:

- ✅ **Flutter** (UI & State Management)
- ✅ **Provider**, **MobX** (State Management)
- ✅ **Hive** (Local Database)
- ✅ **Dependency Injection** (Modular Structure)
- ✅ **Node.js & Express** (Backend API)
- ✅ **FatSecret API** (Feed Data)
- ✅ **Git & GitHub**


---

### Attributes

- **croissant.gif**: <a href="https://www.flaticon.com/free-animated-icons/breakfast" title="breakfast animated icons">Breakfast animated icons created by Freepik - Flaticon</a>
- **pasta.gif**: <a href="https://www.flaticon.com/free-animated-icons/pasta" title="pasta animated icons">Pasta animated icons created by Freepik - Flaticon</a>
- **dinner.gif**: <a href="https://www.flaticon.com/free-animated-icons/dish" title="dish animated icons">Dish animated icons created by Freepik - Flaticon</a>
- **snack.gif**: <a href="https://www.flaticon.com/free-animated-icons/nachos" title="nachos animated icons">Nachos animated icons created by Freepik - Flaticon</a>
- **cookbook.gif**: <a href="https://www.flaticon.com/free-animated-icons/recipe" title="recipe animated icons">Recipe animated icons created by Freepik - Flaticon</a>
