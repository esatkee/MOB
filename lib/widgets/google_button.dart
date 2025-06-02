import 'package:flutter/material.dart';

const String googleLogoUrl =
    'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Logo_2013_Google.png/32px-Logo_2013_Google.png';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String buttonText;
  final String? icon; // <-- Add this line

  const GoogleSignInButton({
    Key? key,
    required this.onPressed,
    required this.isLoading,
    this.buttonText = 'Google ile devam et',
    this.icon, // <-- Add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: isDark ? Colors.grey[600]! : Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            icon ?? googleLogoUrl,
            height: 36,
            width: 36,
          ),
          const SizedBox(width: 12),
          Text(
            buttonText,
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
