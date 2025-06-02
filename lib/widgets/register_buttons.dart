import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/home_page.dart';
import '../functions/register_helpers.dart';

class RegisterButtons extends StatelessWidget {
  final bool isLoading;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;
  final Function(String) onSuccess;
  final Function(bool) setLoading;

  const RegisterButtons({
    super.key,
    required this.isLoading,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    required this.onSuccess,
    required this.setLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        ElevatedButton(
          onPressed: isLoading ? null : () => _registerWithEmail(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: colorScheme.onPrimary,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Create Account', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 16),
        _orDivider(),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: isLoading ? null : () => _signInWithGoogle(context),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Logo_2013_Google.png/32px-Logo_2013_Google.png', height: 24),
              const SizedBox(width: 12),
              const Text('Continue with Google', style: TextStyle(fontSize: 16, color: Colors.black87)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already have an account?', style: TextStyle(color: Colors.grey[600])),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Sign In')),
          ],
        ),
      ],
    );
  }

  void _registerWithEmail(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    setLoading(true);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await insertUserToSupabase(credential.user!.uid);

      onSuccess('Registration successful!');

      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      showError(context, firebaseErrorMessage(e.code));
    } catch (e) {
      showError(context, 'Error: $e');
    } finally {
      setLoading(false);
    }
  }

  void _signInWithGoogle(BuildContext context) async {
    setLoading(true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return setLoading(false);

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      await insertUserToSupabase(authResult.user!.uid);

      onSuccess('Google sign-in successful!');

      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } catch (e) {
      showError(context, 'Google Sign-In Error: $e');
      setLoading(false);
    }
  }

  Widget _orDivider() => Row(
    children: [
      const Expanded(child: Divider()),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text('OR', style: TextStyle(color: Colors.grey[600])),
      ),
      const Expanded(child: Divider()),
    ],
  );
}
