import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/texts.dart';

class ActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const ActionButtons({
    required this.isLoading,
    required this.onCancel,
    required this.onSave,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, -5),
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppConstants.defaultPadding),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).brightness == Brightness.light 
                        ? AppConstants.primaryColor 
                        : theme.colorScheme.primary,
                    side: BorderSide(
                      color: Theme.of(context).brightness == Brightness.light 
                          ? AppConstants.primaryColor 
                          : theme.colorScheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultPadding),
                  ),
                  onPressed: onCancel,
                  child: Text(
                    AppTexts.cancel,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).brightness == Brightness.light 
                          ? AppConstants.primaryColor 
                          : theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).brightness == Brightness.light 
                        ? AppConstants.primaryColor 
                        : theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultPadding),
                    elevation: 4,
                  ),
                  onPressed: isLoading ? null : onSave,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          AppTexts.publish,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.largePadding),
        ],
      ),
    );
  }
}
