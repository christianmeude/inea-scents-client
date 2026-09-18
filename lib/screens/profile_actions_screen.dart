import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/index.dart';

const _primaryColor = Color(0xFF74445C);
const _textColor = Color(0xFF633E50);
const _secondaryTextColor = Color(0xFF765867);

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    nameController = TextEditingController(text: user?.name ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and email are required.')),
      );
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .updateProfile(name: name, email: email);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to update profile.')),
      );
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile details saved.')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'Edit Profile',
      subtitle: 'Update your personal information',
      child: Column(
        children: [
          _ProfileField(label: 'Name', controller: nameController),
          const SizedBox(height: 16),
          _ProfileField(
            label: 'Email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 28),
          _PrimaryButton(label: 'SAVE CHANGES', onPressed: _saveProfile),
        ],
      ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _continue() {
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match.')),
      );
      return;
    }
    context.push('/forgot-password');
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'Change Password',
      subtitle: 'Keep your account secure',
      child: Column(
        children: [
          _ProfileField(
            label: 'Current password',
            controller: currentPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          _ProfileField(
            label: 'New password',
            controller: newPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          _ProfileField(
            label: 'Confirm new password',
            controller: confirmPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 28),
          _PrimaryButton(label: 'CONTINUE', onPressed: _continue),
          TextButton(
            onPressed: () => context.push('/forgot-password'),
            child: const Text('Forgot your current password?'),
          ),
        ],
      ),
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _contactSupport(BuildContext context) async {
    final launched = await launchUrl(
      Uri(
        scheme: 'mailto',
        path: 'support@inea-scents.com',
        queryParameters: {'subject': 'INEA Scents support request'},
      ),
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email app is available.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'Help & Support',
      subtitle: 'Get assistance with your account',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SupportItem(
            icon: Icons.calendar_month_outlined,
            title: 'Bookings',
            text:
                'Need help choosing a date or managing a booking? Contact us and include your booking details.',
          ),
          const SizedBox(height: 16),
          const _SupportItem(
            icon: Icons.lock_outline_rounded,
            title: 'Account access',
            text:
                'For login or password issues, use the password reset flow or contact support.',
          ),
          const SizedBox(height: 28),
          _PrimaryButton(
            label: 'EMAIL SUPPORT',
            onPressed: () => _contactSupport(context),
          ),
        ],
      ),
    );
  }
}

class _SettingsScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SettingsScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E9DF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: _textColor,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _textColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(color: _secondaryTextColor),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  const _ProfileField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: _textColor, fontSize: 16),
      cursorColor: _primaryColor,
      selectionControls: materialTextSelectionControls,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _secondaryTextColor),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.65),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _SupportItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _SupportItem({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _primaryColor, size: 24),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(color: _secondaryTextColor, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
