import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/extensions.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.resetPassword(
      email: _emailController.text.trim(),
    );

    if (mounted) {
      if (success) {
        setState(() {
          _emailSent = true;
        });
        context.showSuccess(AppConstants.successPasswordReset);
      } else if (authProvider.error != null) {
        context.showError(authProvider.error!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spaceLg),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppConstants.spaceXl),

          // Icon
          const Icon(
            Icons.lock_reset,
            size: 80,
            color: AppConstants.primaryPurple,
          ),

          const SizedBox(height: AppConstants.spaceLg),

          // Title
          Text(
            'Forgot Password?',
            style: context.textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.spaceSm),

          Text(
            'Enter your email and we\'ll send you a link to reset your password',
            style: context.textTheme.bodyLarge?.copyWith(
              color: AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.spaceXl),

          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleResetPassword(),
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'your.email@example.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.isValidEmail) {
                return AppConstants.errorInvalidEmail;
              }
              return null;
            },
          ),

          const SizedBox(height: AppConstants.spaceXl),

          // Reset button
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return ElevatedButton(
                onPressed: authProvider.isLoading ? null : _handleResetPassword,
                child: authProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppConstants.neutralBackground,
                          ),
                        ),
                      )
                    : const Text('Send Reset Link'),
              );
            },
          ),

          const SizedBox(height: AppConstants.spaceLg),

          // Back to login
          TextButton(
            onPressed: () {
              context.goBack();
            },
            child: const Text('Back to Sign In'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppConstants.spaceXl),

        // Success icon
        const Icon(
          Icons.check_circle_outline,
          size: 80,
          color: AppConstants.successColor,
        ),

        const SizedBox(height: AppConstants.spaceLg),

        // Title
        Text(
          'Email Sent!',
          style: context.textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConstants.spaceSm),

        Text(
          'We\'ve sent a password reset link to:',
          style: context.textTheme.bodyLarge?.copyWith(
            color: AppConstants.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConstants.spaceSm),

        Text(
          _emailController.text,
          style: context.textTheme.bodyLarge?.copyWith(
            color: AppConstants.accentCyan,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConstants.spaceLg),

        Text(
          'Check your email and follow the link to reset your password.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppConstants.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConstants.spaceXl),

        // Resend button
        OutlinedButton(
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
          child: const Text('Resend Email'),
        ),

        const SizedBox(height: AppConstants.spaceSm),

        // Back to login
        TextButton(
          onPressed: () {
            context.goBack();
          },
          child: const Text('Back to Sign In'),
        ),
      ],
    );
  }
}
