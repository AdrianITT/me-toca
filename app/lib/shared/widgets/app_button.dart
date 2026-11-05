import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';

enum AppButtonVariant { primary, secondary }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isPrimary = variant == AppButtonVariant.primary;

    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isPrimary ? palette.primary : palette.surface,
          foregroundColor: isPrimary ? palette.onPrimary : palette.primary,
          disabledBackgroundColor: isPrimary
              ? palette.surfaceAlt
              : palette.surface,
          disabledForegroundColor: palette.inkMuted,
          elevation: 0,
          shape: AppRadii.stadium,
          side: isPrimary ? BorderSide.none : BorderSide(color: palette.border),
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: palette.onPrimary,
                ),
              )
            : Text(label),
      ),
    );
  }
}
