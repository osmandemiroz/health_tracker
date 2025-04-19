import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calory_tool/core/providers/goal_provider.dart';
import 'package:calory_tool/core/providers/user_provider.dart';

/// A screen for creating new goals
///
/// Follows Apple's Human Interface Guidelines with a clean, minimalist design.
/// Features smooth animations and intuitive input controls for goal creation.
class GoalCreationScreen extends StatefulWidget {
  const GoalCreationScreen({Key? key}) : super(key: key);

  @override
  State<GoalCreationScreen> createState() => _GoalCreationScreenState();
}

class _GoalCreationScreenState extends State<GoalCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _targetCaloriesController = TextEditingController();
  final _notesController = TextEditingController();

  // Form values
  String _selectedGoalType = 'Weight Loss';
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  String? _caloriesError;

  // Available goal types
  final List<String> _goalTypes = [
    'Weight Loss',
    'Muscle Gain',
    'Maintenance',
    'Custom',
  ];

  @override
  void dispose() {
    _targetCaloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _validateCalories() {
    final value = _targetCaloriesController.text;
    if (value.isEmpty) {
      setState(() => _caloriesError = 'Please enter target calories');
      return false;
    }
    final calories = int.tryParse(value);
    if (calories == null || calories <= 0) {
      setState(() => _caloriesError = 'Please enter a valid calorie target');
      return false;
    }
    setState(() => _caloriesError = null);
    return true;
  }

  Future<void> _createGoal() async {
    if (!_validateCalories()) return;

    final goalProvider = context.read<GoalProvider>();
    final userProvider = context.read<UserProvider>();
    final currentUser = userProvider.currentUser;

    if (currentUser == null) {
      _showError('User not found. Please try again.');
      return;
    }

    final calories = int.tryParse(_targetCaloriesController.text)!;

    try {
      await goalProvider.createGoal(
        userId: currentUser.uid,
        goalType: _selectedGoalType,
        startDate: DateTime.now(),
        targetCalories: calories,
        endDate: _endDate,
        notes: _notesController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showError('Failed to create goal. Please try again.');
    }
  }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CupertinoButton(
          child: const Icon(
            CupertinoIcons.back,
            color: CupertinoColors.activeBlue,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create Goal',
          style: TextStyle(
            color: CupertinoColors.label,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Goal Type Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Goal Type',
                  style: TextStyle(
                    color: CupertinoColors.secondaryLabel,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CupertinoSlidingSegmentedControl<String>(
                    groupValue: _selectedGoalType,
                    children: {
                      for (final type in _goalTypes)
                        type: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(type),
                        ),
                    },
                    onValueChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedGoalType = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Target Calories Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Target Daily Calories',
                  style: TextStyle(
                    color: CupertinoColors.secondaryLabel,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoTextField(
                      controller: _targetCaloriesController,
                      keyboardType: TextInputType.number,
                      placeholder: 'Enter target calories',
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemBackground,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            _caloriesError != null
                                ? Border.all(
                                  color: CupertinoColors.destructiveRed,
                                )
                                : null,
                      ),
                      onChanged: (value) {
                        if (_caloriesError != null) {
                          _validateCalories();
                        }
                      },
                    ),
                    if (_caloriesError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _caloriesError!,
                        style: const TextStyle(
                          color: CupertinoColors.destructiveRed,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // End Date Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'End Date',
                  style: TextStyle(
                    color: CupertinoColors.secondaryLabel,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    minimumDate: DateTime.now(),
                    maximumDate: DateTime.now().add(const Duration(days: 365)),
                    initialDateTime: _endDate,
                    onDateTimeChanged: (date) {
                      setState(() => _endDate = date);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Notes Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notes (Optional)',
                  style: TextStyle(
                    color: CupertinoColors.secondaryLabel,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: _notesController,
                  placeholder: 'Add notes about your goal',
                  padding: const EdgeInsets.all(12),
                  maxLines: 4,
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Create Button
            CupertinoButton.filled(
              onPressed: _createGoal,
              child: const Text('Create Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
