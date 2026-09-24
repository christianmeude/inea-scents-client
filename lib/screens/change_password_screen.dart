import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/theme.dart';
import '../widgets/index.dart';

/// C39 (spec/UX scaffold, owner gate before merge — C15 wiring stays open):
/// change-password form shell at `/profile/password`. No API calls.
///
/// Field contracts mirror backend A7 so C15 wiring needs no rework:
/// - current  -> `current_password` (wrong current rejected)
/// - new      -> `password` (min 8)
/// - confirm  -> `password_confirmation` (must match `password`)
/// - code     -> `code` (6 digits; wrong code rejected; success revokes
///   other Sanctum tokens only, current session kept)
class ChangePasswordValidators {
  static String? validateCurrent(String value) {
    if (value.isEmpty) return 'Enter your current password.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    return null;
  }

  static String? validateNew(String value, String current) {
    if (value.isEmpty) return 'Enter a new password.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    if (current.isNotEmpty && value == current) {
      return 'New password must differ from the current password.';
    }
    return null;
  }

  static String? validateConfirm(String value, String next) {
    if (value.isEmpty) return 'Confirm your new password.';
    if (value != next) return 'Passwords do not match.';
    return null;
  }

  static String? validateCode(String value) {
    if (value.isEmpty) return 'Enter the 6-digit code.';
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Code must be 6 digits.';
    }
    return null;
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  final _codeController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  /// Fields show inline errors only after user interaction.
  final _touched = <String, bool>{};

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _touch(String key) {
    if (_touched[key] != true) setState(() => _touched[key] = true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? const Color(0xFFFDF4F5)
        : const Color(0xFF633E50);
    final secondaryTextColor = isDark
        ? const Color(0xFFC4ACAC)
        : const Color(0xFF765867);

    final currentError = _touched['current'] == true
        ? ChangePasswordValidators.validateCurrent(
            _currentController.text,
          )
        : null;
    final newError = _touched['new'] == true
        ? ChangePasswordValidators.validateNew(
            _newController.text,
            _currentController.text,
          )
        : null;
    final confirmError = _touched['confirm'] == true
        ? ChangePasswordValidators.validateConfirm(
            _confirmController.text,
            _newController.text,
          )
        : null;
    final codeError = _touched['code'] == true
        ? ChangePasswordValidators.validateCode(_codeController.text)
        : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Change Password'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // C40: clamp overscroll on mobile (<768px); SDK default
            // (stretch Android / bounce iOS) displaced content past edge.
            physics: MobileClampScroll.physicsOf(context),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enter your current password, choose a new one, and confirm the 6-digit code.',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: CardSurfaces.cardBg(context),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: CardSurfaces.cardBorder(context),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CardSurfaces.plum.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          key: const Key('change_password_current'),
                          controller: _currentController,
                          obscureText: _obscureCurrent,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: 'Current password',
                            suffixIcon: IconButton(
                              mouseCursor: SystemMouseCursors.click,
                              onPressed: () => setState(
                                () => _obscureCurrent = !_obscureCurrent,
                              ),
                              icon: Icon(
                                _obscureCurrent
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 18,
                              ),
                            ),
                          ),
                          onChanged: (_) => _touch('current'),
                        ),
                        InlineFieldError(
                          key: const Key('change_password_current_error'),
                          message: currentError,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('change_password_new'),
                          controller: _newController,
                          obscureText: _obscureNew,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                          decoration: InputDecoration(
                            labelText: 'New password',
                            suffixIcon: IconButton(
                              mouseCursor: SystemMouseCursors.click,
                              onPressed: () => setState(
                                () => _obscureNew = !_obscureNew,
                              ),
                              icon: Icon(
                                _obscureNew
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 18,
                              ),
                            ),
                          ),
                          onChanged: (_) {
                            _touch('new');
                            if (_touched['confirm'] == true) setState(() {});
                          },
                        ),
                        InlineFieldError(
                          key: const Key('change_password_new_error'),
                          message: newError,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('change_password_confirm'),
                          controller: _confirmController,
                          obscureText: _obscureConfirm,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                          decoration: InputDecoration(
                            labelText: 'Confirm new password',
                            suffixIcon: IconButton(
                              mouseCursor: SystemMouseCursors.click,
                              onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 18,
                              ),
                            ),
                          ),
                          onChanged: (_) => _touch('confirm'),
                        ),
                        InlineFieldError(
                          key: const Key('change_password_confirm_error'),
                          message: confirmError,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('change_password_code'),
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.oneTimeCode],
                          decoration: const InputDecoration(
                            labelText: '6-digit code',
                            hintText: '123456',
                          ),
                          onChanged: (_) => _touch('code'),
                        ),
                        InlineFieldError(
                          key: const Key('change_password_code_error'),
                          message: codeError,
                        ),
                        const SizedBox(height: 24),
                        // C39: scaffold only — submit stays disabled until
                        // C15 wiring. No onPressed, no API calls.
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            key: const Key('change_password_submit'),
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme.primaryButtonBackground,
                              foregroundColor: AppTheme.onPrimaryButton,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'CHANGE PASSWORD',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
