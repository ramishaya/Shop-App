import 'package:flutter/material.dart';

class ShopsSearchField extends StatelessWidget {
  const ShopsSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.hintText,
    required this.showClearButton,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String hintText;
  final bool showClearButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 54,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(.75),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          suffixIcon: showClearButton
              ? IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded),
                )
              : null,
          filled: true,
          fillColor: isDark ? const Color(0xFF1B1F28) : const Color(0xFFF1F1F1),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide(
              color: theme.colorScheme.primary.withOpacity(.22),
              width: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
