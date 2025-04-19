import 'package:calory_tool/data/models/user/user_model.dart';

/// A class representing the result of a repository operation
class Result<T> {
  final T? data;
  final Exception? error;
  final bool isSuccess;

  Result.success(this.data) : error = null, isSuccess = true;
  Result.failure(this.error) : data = null, isSuccess = false;

  void when({
    required Function(T data) onSuccess,
    required Function(Failure error) onFail,
  }) {
    if (isSuccess && data != null) {
      onSuccess(data!);
    } else if (!isSuccess && error != null) {
      onFail(Failure(error!));
    }
  }
}

/// A class representing a repository operation failure
class Failure {
  final Exception error;

  Failure(this.error);
}

/// Repository interface for User operations
abstract class UserRepository {
  /// Get current logged-in user
  Future<Result<UserModel>> getCurrentUser();

  /// Get user by ID
  Future<Result<UserModel>> getUserById(String uid);

  /// Create a new user
  Future<Result<UserModel>> createUser(UserModel user);

  /// Update an existing user
  Future<Result<UserModel>> updateUser(UserModel user);

  /// Update user dietary preferences
  Future<Result<UserModel>> updateDietaryPreferences(
    String uid,
    List<String> preferences,
  );

  /// Update user allergies
  Future<Result<UserModel>> updateAllergies(String uid, List<String> allergies);

  /// Delete a user
  Future<Result<bool>> deleteUser(String uid);
}
