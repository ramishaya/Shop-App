import 'package:flutter/material.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.searchField,
    required this.onFilterTap,
    required this.hasActiveFilters,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  final String title;
  final String subtitle;
  final Widget searchField;
  final VoidCallback onFilterTap;
  final bool hasActiveFilters;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color accentColor = isDark
        ? const Color(0xFFC79A63)
        : const Color(0xFFB98552);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.08,
                    letterSpacing: -.6,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _HeaderThemeButton(
              onTap: onThemeToggle,
              accentColor: accentColor,
              isDarkMode: isDarkMode,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(child: searchField),
            const SizedBox(width: 12),
            _HeaderFilterButton(
              onTap: onFilterTap,
              accentColor: accentColor,
              hasActiveFilters: hasActiveFilters,
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderThemeButton extends StatelessWidget {
  const _HeaderThemeButton({
    required this.onTap,
    required this.accentColor,
    required this.isDarkMode,
  });

  final VoidCallback onTap;
  final Color accentColor;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: accentColor.withOpacity(.12),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 43,
          height: 43,
          child: Icon(
            isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: accentColor,
            size: 21,
          ),
        ),
      ),
    );
  }
}

class _HeaderFilterButton extends StatelessWidget {
  const _HeaderFilterButton({
    required this.onTap,
    required this.accentColor,
    required this.hasActiveFilters,
  });

  final VoidCallback onTap;
  final Color accentColor;
  final bool hasActiveFilters;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: accentColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 43,
          height: 43,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
              if (hasActiveFilters)
                PositionedDirectional(
                  top: 11,
                  end: 11,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.6),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}