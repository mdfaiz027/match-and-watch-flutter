import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/constants/app_styles.dart';
import '../bloc/user_cubit.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _movieTasteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _movieTasteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final fullName = _nameController.text.trim();
      final movieTaste = _movieTasteController.text.trim();

      // Call createUser on UserCubit
      await context.read<UserCubit>().createUser(
        fullName: fullName,
        movieTaste: movieTaste,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.addUserSuccess),
            backgroundColor: AppColors.primaryGold,
          ),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.textMain),
                decoration: AppStyles.inputDecoration(
                  label: 'Name',
                  borderRadius: AppDimensions.cardRadius,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacingL),
              TextFormField(
                controller: _movieTasteController,
                style: const TextStyle(color: AppColors.textMain),
                decoration: AppStyles.inputDecoration(
                  label: 'Movie Taste',
                  borderRadius: AppDimensions.cardRadius,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter movie taste';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacingXXL),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
