import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/index.dart';
import '../widgets/index.dart';

// ============================================================================
// EDIT PROFILE SCREEN (C38: scaffolded deferred form — no wiring, C14 open)
// ============================================================================
//
// Field contracts match backend A6 so C14 wiring needs no rework:
// - name updates inline (prefilled from the current User).
// - email swaps only after code verify: the new address goes in the email
//   field, the mailed code goes in the verification-code field, and the
//   current address stays the login until the swap completes.
// - phone mirrors the removed C29 card field.

/// Name must be non-blank.
String? validateProfileName(String? value) {
  if (value == null || value.trim().isEmpty) return 'Enter your name';
  if (value.trim().length < 2) return 'Name must be at least 2 characters';
  return null;
}

/// New email is optional (blank keeps the current login); when filled it
/// must be a valid address awaiting code verification.
String? validateProfileEmail(String? value) {
  final text = value == null ? '' : value.trim();
  if (text.isEmpty) return null;
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
    return 'Enter a valid email address';
  }
  return null;
}

/// Verification code: required when a new email is entered, otherwise
/// optional; whenever filled it must be 6 digits.
String? validateProfileCode(String? value, String emailValue) {
  final code = value == null ? '' : value.trim();
  final wantsSwap = emailValue.trim().isNotEmpty;
  if (code.isEmpty) {
    if (wantsSwap) return 'Enter the 6-digit code';
    return null;
  }
  if (!RegExp(r'^\d{6}$').hasMatch(code)) return 'Code must be 6 digits';
  return null;
}

/// Phone is optional; when filled it must look like a phone number.
String? validateProfilePhone(String? value) {
  final text = value == null ? '' : value.trim();
  if (text.isEmpty) return null;
  if (!RegExp(r'^[+0-9][0-9 ()\-]{5,}$').hasMatch(text)) {
    return 'Enter a valid phone number';
  }
  return null;
}

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _codeController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController();
    _codeController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = CardSurfaces.cardBg(context);
    final cardBorder = CardSurfaces.cardBorder(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: cardBorder, width: 1),
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        key: const Key('edit_profile_name'),
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: validateProfileName,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('edit_profile_email'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        decoration: const InputDecoration(
                          labelText: 'New email',
                          helperText:
                              'Your current email stays your login until a '
                              'new one is verified.',
                        ),
                        validator: validateProfileEmail,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('edit_profile_code'),
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        decoration: const InputDecoration(
                          labelText: 'Verification code',
                        ),
                        validator: (value) => validateProfileCode(
                          value,
                          _emailController.text,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('edit_profile_phone'),
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [
                          AutofillHints.telephoneNumber,
                        ],
                        decoration: const InputDecoration(labelText: 'Phone'),
                        validator: validateProfilePhone,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          key: const Key('edit_profile_submit'),
                          // C38: scaffold only — no wiring (C14 stays open).
                          onPressed: null,
                          child: const Text('Save changes'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
