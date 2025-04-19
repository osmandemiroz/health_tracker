import 'package:calory_tool/data/models/user/user_model.dart';
import 'package:calory_tool/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';

/// Provider for managing user-related state and operations
class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;

  /// The currently logged-in user
  UserModel? currentUser;

  /// Loading state indicator
  bool isLoading = false;

  /// Error message if any
  String? errorMessage;

  UserProvider(this._userRepository);

  /// Initialize the provider by loading the current user
  Future<void> init() async {
    await getCurrentUser();
  }

  /// Get the current logged-in user
  Future<void> getCurrentUser() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _userRepository.getCurrentUser();
    result.when(
      onSuccess: (user) {
        currentUser = user;
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// Create a new user
  Future<void> createUser(UserModel user) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _userRepository.createUser(user);
    result.when(
      onSuccess: (newUser) {
        currentUser = newUser;
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// Update the current user's profile
  Future<void> updateProfile(UserModel updatedUser) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _userRepository.updateUser(updatedUser);
    result.when(
      onSuccess: (user) {
        currentUser = user;
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// Update the current user's dietary preferences
  Future<void> updateDietaryPreferences(List<String> preferences) async {
    if (currentUser == null) {
      errorMessage = 'No user logged in';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _userRepository.updateDietaryPreferences(
      currentUser!.uid,
      preferences,
    );
    result.when(
      onSuccess: (user) {
        currentUser = user;
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// Update the current user's allergies
  Future<void> updateAllergies(List<String> allergies) async {
    if (currentUser == null) {
      errorMessage = 'No user logged in';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _userRepository.updateAllergies(
      currentUser!.uid,
      allergies,
    );
    result.when(
      onSuccess: (user) {
        currentUser = user;
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// Clear current user (useful when logging out)
  void clearUser() {
    currentUser = null;
    errorMessage = null;
    notifyListeners();
  }
}
