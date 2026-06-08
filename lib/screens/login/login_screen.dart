import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass_container.dart';

/// Login screen — pixel-perfect port of Login.jsx.
/// Email auth with sign-up toggle, glassmorphic card, branded header.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isSignup = false;
  bool _showPassword = false;
  bool _submitting = false;
  String _error = '';
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() { _submitting = true; _error = ''; });
    try {
      final auth = ref.read(authProvider.notifier);
      if (_isSignup) {
        await auth.signupWithEmail(_emailC.text.trim(), _passwordC.text, _nameC.text.trim());
      } else {
        await auth.loginWithEmail(_emailC.text.trim(), _passwordC.text);
      }
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString()
            .replaceAll('Exception: ', '')
            .replaceAll(RegExp(r'\[.*?\]'), '')
            .replaceAll('Firebase: ', '')
            .replaceAll(RegExp(r'\(auth/.*\)'), '')
            .trim());
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: GlassContainer(
            borderRadius: 24,
            blur: 24,
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Logo ──
                Image.asset(
                  'assets/logo.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
                Transform.translate(
                  offset: const Offset(7, 0),
                  child: const Text('PULSE',
                      style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 14,
                          color: Colors.white)),
                ),
                const SizedBox(height: 4),
                const Text('Feel Every Beat!',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: GestureDetector(
                    onTap: () => launchUrl(
                      Uri.parse('https://itsashutoshpathak.vercel.app/'),
                      mode: LaunchMode.externalApplication,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Made with ❤️ by ',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary.withValues(alpha: 0.7))),
                        Text('Ashutosh Pathak',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold, color: accent)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Name (signup) ──
                if (_isSignup)
                  _buildInput(
                    controller: _nameC,
                    hint: 'Your name',
                  ),

                // ── Email ──
                _buildInput(
                  controller: _emailC,
                  hint: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                ),

                // ── Password ──
                _buildInput(
                  controller: _passwordC,
                  hint: 'Password',
                  obscure: !_showPassword,
                  suffix: GestureDetector(
                    onTap: () => setState(() => _showPassword = !_showPassword),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        _showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),

                // ── Error ──
                if (_error.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(_error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.danger)),
                ],

                const SizedBox(height: 16),

                // ── Submit ──
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Text(
                            _isSignup ? 'Create Account' : 'Sign In',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black)),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Toggle ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isSignup
                          ? 'Already have an Pulse account? '
                          : "Don't have an Pulse account? ",
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        _isSignup = !_isSignup;
                        _error = '';
                      }),
                      child: Text(
                        _isSignup ? 'Sign In' : 'Sign Up',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700,
                            color: accent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscure,
                keyboardType: keyboardType,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            if (suffix != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: suffix,
              ),
          ],
        ),
      ),
    );
  }
}
