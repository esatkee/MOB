import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/login_form.dart';
import '../widgets/google_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

// Giriş sayfası - Email/şifre, Google ve GitHub ile giriş sağlar
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _obscurePassword = true;
  bool _isLoading = false;
  String _successMessage = '';

  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Email ve şifre ile giriş yapma işlemi
  Future<void> _loginWithEmailPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _successMessage = "Giriş başarılı!";
      });

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Bir hata oluştu';
      if (e.code == 'user-not-found') {
        errorMessage = 'Bu e-posta adresiyle kayıtlı kullanıcı bulunamadı.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Yanlış şifre girdiniz.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Geçersiz e-posta adresi.';
      }
      _showError(errorMessage);
    } catch (e) {
      _showError('Hata: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Google ile giriş işlemi
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      setState(() {
        _successMessage = "Google ile giriş başarılı!";
      });

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      _showError('Google Giriş Hatası: $e');
      setState(() => _isLoading = false);
    }
  }

  // GitHub ile giriş işlemi
  Future<void> _signInWithGitHub() async {
    setState(() => _isLoading = true);

    try {
      final githubProvider = GithubAuthProvider();

      // signInWithProvider, FlutterFire 4.5+ ile gelen yeni yöntem
      final result = await _auth.signInWithProvider(githubProvider);

      if (result.user != null) {
        setState(() {
          _successMessage = "GitHub ile giriş başarılı!";
        });

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      _showError('GitHub Giriş Hatası: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(title: "Giriş Yap"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Tekrar Hoş Geldiniz!",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox.fromSize(size: const Size.fromHeight(8)),
            Text(
              "Devam etmek için giriş yapın...",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Image.network(
              'https://jspsknitanbilrnavgmu.supabase.co/storage/v1/object/public/img//logo.png',
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            EmailPasswordForm(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              obscurePassword: _obscurePassword,
              toggleObscurePassword: _toggleObscurePassword,
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _loginWithEmailPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _isLoading
                  ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: colorScheme.onPrimary,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                'Giriş Yap',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Divider(color: colorScheme.outline.withOpacity(0.5)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'VEYA',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(color: colorScheme.outline.withOpacity(0.5)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GoogleSignInButton(
              isLoading: _isLoading,
              onPressed: _signInWithGoogle,
              buttonText: 'Google ile devam et',
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.code),
              label: Text(
                'GitHub ile devam et',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _isLoading ? null : _signInWithGitHub,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hesabınız yok mu?",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Kayıt Ol',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
              ],
            ),
            if (_successMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _successMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
