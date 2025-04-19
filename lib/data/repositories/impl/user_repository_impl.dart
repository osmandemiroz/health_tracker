import 'package:calory_tool/data/models/user/user_model.dart';
import 'package:calory_tool/data/repositories/user_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Implementation of UserRepository that uses Hive for storage
class UserRepositoryImpl implements UserRepository {
  static const String _boxName = 'users';
  static const String _currentUserKey = 'current_user';

  late final Box<UserModel> _userBox;

  /// Initialize the repository
  Future<void> init() async {
    _userBox = await Hive.openBox<UserModel>(_boxName);
  }

  @override
  Future<Result<UserModel>> getCurrentUser() async {
    try {
      final user = _userBox.get(_currentUserKey);
      if (user == null) {
        return Result.failure(Exception('No current user found'));
      }
      return Result.success(user);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<UserModel>> getUserById(String uid) async {
    try {
      final user = _userBox.get(uid);
      if (user == null) {
        return Result.failure(Exception('User not found'));
      }
      return Result.success(user);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<UserModel>> createUser(UserModel user) async {
    try {
      await _userBox.put(user.uid, user);
      // Set as current user if none exists
      if (!_userBox.containsKey(_currentUserKey)) {
        await _userBox.put(_currentUserKey, user);
      }
      return Result.success(user);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<UserModel>> updateUser(UserModel user) async {
    try {
      await _userBox.put(user.uid, user);
      // Update current user if this is the current user
      final currentUser = _userBox.get(_currentUserKey);
      if (currentUser?.uid == user.uid) {
        await _userBox.put(_currentUserKey, user);
      }
      return Result.success(user);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<UserModel>> updateDietaryPreferences(
    String uid,
    List<String> preferences,
  ) async {
    try {
      final userResult = await getUserById(uid);
      if (userResult.isSuccess && userResult.data != null) {
        final user = userResult.data!;
        final updatedUser = UserModel(
          uid: user.uid,
          name: user.name,
          email: user.email,
          accountCreationDate: user.accountCreationDate,
          phoneNumber: user.phoneNumber,
          address: user.address,
          accessLevel: user.accessLevel,
          dietaryPreferences: preferences,
          allergies: user.allergies,
          profileImageUrl: user.profileImageUrl,
        );
        return updateUser(updatedUser);
      }
      return Result.failure(Exception('Failed to update dietary preferences'));
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<UserModel>> updateAllergies(
    String uid,
    List<String> allergies,
  ) async {
    try {
      final userResult = await getUserById(uid);
      if (userResult.isSuccess && userResult.data != null) {
        final user = userResult.data!;
        final updatedUser = UserModel(
          uid: user.uid,
          name: user.name,
          email: user.email,
          accountCreationDate: user.accountCreationDate,
          phoneNumber: user.phoneNumber,
          address: user.address,
          accessLevel: user.accessLevel,
          dietaryPreferences: user.dietaryPreferences,
          allergies: allergies,
          profileImageUrl: user.profileImageUrl,
        );
        return updateUser(updatedUser);
      }
      return Result.failure(Exception('Failed to update allergies'));
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool>> deleteUser(String uid) async {
    try {
      await _userBox.delete(uid);
      // If this was the current user, remove it
      final currentUser = _userBox.get(_currentUserKey);
      if (currentUser?.uid == uid) {
        await _userBox.delete(_currentUserKey);
      }
      return Result.success(true);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
