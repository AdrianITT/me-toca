import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.helper,
    this.errorText,
    this.hint,
    this.suffix,
    this.keyboardType,
    this.inputFormatters,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? helper;
  final String? errorText;
  final String? hint;
  final String? suffix;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge?.copyWith(color: palette.ink)),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          onChanged: onChanged,
          style: textTheme.bodyLarge?.copyWith(color: palette.ink),
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            errorText: errorText,
          ),
        ),
        if (helper != null && errorText == null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            helper!,
            style: textTheme.bodySmall?.copyWith(color: palette.inkMuted),
          ),
        ],
      ],
    );
  }
}
