import 'package:calory_tool/core/providers/meal_plan_provider.dart';
import 'package:calory_tool/core/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A screen for creating new meal plans
class MealPlanCreationScreen extends StatefulWidget {
  const MealPlanCreationScreen({super.key});

  @override
  State<MealPlanCreationScreen> createState() => _MealPlanCreationScreenState();
}

class _MealPlanCreationScreenState extends State<MealPlanCreationScreen> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _createMealPlan() async {
    final mealPlanProvider = context.read<MealPlanProvider>();
    final userProvider = context.read<UserProvider>();
    final currentUser = userProvider.currentUser;

    if (currentUser == null) {
      _showError('User not found. Please try again.');
      return;
    }

    try {
      await mealPlanProvider.createMealPlan(
        userId: currentUser.uid,
        date: _selectedDate,
        name: _nameController.text.trim(),
        notes: _notesController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showError('Failed to create meal plan. Please try again.');
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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Create Meal Plan'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date Picker
              _buildDatePicker(),
              const SizedBox(height: 24),

              // Name Field
              CupertinoTextField(
                controller: _nameController,
                placeholder: 'Plan Name (optional)',
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey4),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),

              // Notes Field
              CupertinoTextField(
                controller: _notesController,
                placeholder: 'Notes (optional)',
                padding: const EdgeInsets.all(12),
                maxLines: 4,
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey4),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 32),

              // Create Button
              Consumer<MealPlanProvider>(
                builder: (context, provider, child) {
                  return CupertinoButton.filled(
                    onPressed: provider.isLoading ? null : _createMealPlan,
                    child:
                        provider.isLoading
                            ? const CupertinoActivityIndicator()
                            : const Text('Create Meal Plan'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.systemGrey4),
            borderRadius: BorderRadius.circular(8),
          ),
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            minimumDate: DateTime.now(),
            maximumDate: DateTime.now().add(const Duration(days: 365)),
            onDateTimeChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ),
      ],
    );
  }
}
