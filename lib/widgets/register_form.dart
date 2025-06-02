import 'package:flutter/material.dart';
import 'register_buttons.dart';
import '../functions/register_helpers.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _successMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Welcome To Diary+!",
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Create an account to continue",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 16),
          _buildConfirmPasswordField(),
          const SizedBox(height: 24),
          RegisterButtons(
            isLoading: _isLoading,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            formKey: _formKey,
            onSuccess: (msg) => setState(() => _successMessage = msg),
            setLoading: (val) => setState(() => _isLoading = val),
          ),
          if (_successMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _successMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmailField() => TextFormField(
    controller: _emailController,
    decoration: _inputDecoration("Email", Icons.email),
    keyboardType: TextInputType.emailAddress,
    validator: validateEmail,
  );

  Widget _buildPasswordField() => TextFormField(
    controller: _passwordController,
    obscureText: _obscurePassword,
    decoration: _inputDecoration(
      "Password",
      Icons.lock,
      isPassword: true,
      onVisibilityToggle: () {
        setState(() => _obscurePassword = !_obscurePassword);
      },
      obscure: _obscurePassword,
    ),
    validator: validatePassword,
  );

  Widget _buildConfirmPasswordField() => TextFormField(
    controller: _confirmPasswordController,
    obscureText: _obscureConfirmPassword,
    decoration: _inputDecoration(
      "Confirm Password",
      Icons.lock,
      isPassword: true,
      onVisibilityToggle: () {
        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
      },
      obscure: _obscureConfirmPassword,
    ),
    validator: (value) => validateConfirmPassword(value, _passwordController.text),
  );

  InputDecoration _inputDecoration(
      String label,
      IconData icon, {
        bool isPassword = false,
        VoidCallback? onVisibilityToggle,
        bool obscure = true,
      }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      suffixIcon: isPassword
          ? IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: onVisibilityToggle,
      )
          : null,
    );
  }
}
