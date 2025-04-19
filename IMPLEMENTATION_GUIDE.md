# Health Tracker Implementation Guide

This guide provides instructions on how to implement the missing features outlined in the PRD.

## Prerequisites

Before proceeding with implementation, make sure to run the code generator to create the Hive adapters for the new models:

```bash
./scripts/generate_code.sh
```

## 1. User Authentication and Profile Management

### Steps:
1. Create a user authentication service using Firebase Authentication or a custom backend
2. Implement user registration screen with fields for:
   - Name
   - Email
   - Password
   - Phone number (optional)
   - Address (optional)
   - Dietary preferences
   - Allergies
3. Create a user profile screen for viewing and editing profile information
4. Implement UserProvider for state management

### Example Code:
```dart
// Example of UserProvider implementation
import 'package:flutter/material.dart';
import 'package:calory_tool/data/models/user/user_model.dart';
import 'package:calory_tool/data/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;
  UserModel? currentUser;
  bool isLoading = false;

  UserProvider(this._userRepository);

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    
    // Implementation of login logic
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> register(UserModel user, String password) async {
    // Implementation of registration logic
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    // Implementation of profile update logic
  }
}
```

## 2. Goal Setting and Tracking ✅

### Completed Implementation:
1. ✅ Created GoalModel with Hive adapter
2. ✅ Implemented GoalRepository interface and Hive-based implementation
3. ✅ Created GoalProvider for state management
4. ✅ Implemented UI screens following Apple's Human Interface Guidelines:
   - Goal creation screen:
     * Clean, hierarchical layout with proper spacing
     * Native iOS-style CupertinoTextField for input
     * CupertinoSlidingSegmentedControl for goal type selection
     * CupertinoDatePicker for date selection
     * Real-time validation with visual feedback
     * Smooth animations for state changes
   - Goal list screen:
     * Modern list design with clear visual hierarchy
     * Pull-to-refresh functionality
     * Swipe actions for quick updates/deletion
     * Progress indicators using iOS-native styling
     * Context menus for additional actions
   - Goal progress updates:
     * Interactive progress adjustment
     * Haptic feedback on changes
     * Animated transitions
   - Confirmation dialogs using CupertinoAlertDialog

### Example Usage:
```dart
// Creating a new goal
final goalProvider = context.read<GoalProvider>();
await goalProvider.createGoal(
  userId: currentUser.uid,
  goalType: 'Weight Loss',
  startDate: DateTime.now(),
  endDate: endDate,
  targetCalories: 2000,
  notes: 'My weight loss journey',
);

// Updating goal progress
await goalProvider.updateGoalProgress(goalId, 0.75); // 75% complete
```

## 3. Meal Planning Interface

### Steps:
1. Implement a calendar view for selecting dates for meal planning
2. Create a meal plan creation screen with ability to add recipes to:
   - Breakfast
   - Lunch
   - Dinner
   - Snacks
3. Implement a meal plan details screen showing all recipes for a specific day
4. Create a weekly meal plan view
5. Implement a MealPlanProvider for state management

### Example Code:
```dart
// Example of MealPlanProvider implementation
import 'package:flutter/material.dart';
import 'package:calory_tool/data/models/meal_plan/meal_plan_model.dart';
import 'package:calory_tool/data/repositories/meal_plan_repository.dart';
import 'package:calory_tool/enum/planned_meals_enum.dart';

class MealPlanProvider extends ChangeNotifier {
  final MealPlanRepository _mealPlanRepository;
  List<MealPlanModel> userMealPlans = [];
  bool isLoading = false;

  MealPlanProvider(this._mealPlanRepository);

  Future<void> fetchUserMealPlans(String userId) async {
    isLoading = true;
    notifyListeners();
    
    // Implementation to fetch user meal plans
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> createMealPlan(MealPlanModel mealPlan) async {
    // Implementation to create a new meal plan
  }

  Future<void> addRecipeToMealPlan(
    String mealPlanId, 
    PlannedMealsEnum mealType, 
    String recipeId
  ) async {
    // Implementation to add a recipe to a meal plan
  }
}
```

## 4. Nutritional Analysis

### Steps:
1. Implement daily nutritional intake calculation based on planned meals
2. Create a nutritional dashboard showing:
   - Daily calorie intake
   - Protein, carbs, and fat breakdown
   - Micronutrient information
3. Implement comparison with user goals
4. Create charts and visualizations for nutritional data

### Example Charts Implementation:
```dart
// Example of nutritional charts using fl_chart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MacronutrientChart extends StatelessWidget {
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;

  const MacronutrientChart({
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = proteinGrams + carbsGrams + fatGrams;
    
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: proteinGrams,
              title: 'Protein',
              color: Colors.red,
              radius: 60,
            ),
            PieChartSectionData(
              value: carbsGrams,
              title: 'Carbs',
              color: Colors.blue,
              radius: 60,
            ),
            PieChartSectionData(
              value: fatGrams,
              title: 'Fat',
              color: Colors.yellow,
              radius: 60,
            ),
          ],
        ),
      ),
    );
  }
}
```

## 5. Recipe Recommendations

### Steps:
1. Implement an algorithm to match recipes with user preferences and goals
2. Create a recommendation engine that considers:
   - User dietary preferences
   - User allergies
   - User nutritional goals
   - Previous meal history
3. Design a recommendation UI that displays:
   - Recommended recipes
   - Reason for recommendation
   - Nutritional alignment with goals

### Example Recommendation Logic:
```dart
// Example of recommendation service
class RecipeRecommendationService {
  List<RecipeModel> recommendRecipesForUser(
    UserModel user,
    GoalModel? activeGoal,
    List<RecipeModel> allRecipes,
  ) {
    // Filter by dietary preferences and allergies
    final filteredRecipes = allRecipes.where((recipe) {
      return !recipe.ingredients.any((ingredient) =>
        user.allergies.contains(ingredient));
    }).toList();
    
    // Sort by goal alignment
    if (activeGoal != null) {
      filteredRecipes.sort((a, b) {
        if (activeGoal.goalType == 'Weight Loss') {
          return a.calories.compareTo(b.calories);
        }
        return 0;
      });
    }
    
    return filteredRecipes.take(10).toList();
  }
}
```

## 6. Admin Functionality

### Steps:
1. Create an admin dashboard with:
   - User management
   - Recipe management
   - Content moderation
2. Implement role-based authentication
3. Create interfaces for adding and editing recipes
4. Implement analytics and reporting features

## Next Steps

After implementing these features:

1. Conduct comprehensive testing
2. Gather user feedback
3. Implement UI refinements
4. Optimize performance
5. Add additional features as needed

## Best Practices

1. Follow a consistent code style
2. Write unit tests for all new functionality
3. Use proper error handling and validation
4. Optimize database queries
5. Ensure accessibility compliance
6. Follow Flutter's recommended patterns 