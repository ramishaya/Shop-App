import 'package:flutter/material.dart';

class HomeSummaryRow extends StatelessWidget {
  const HomeSummaryRow({
    super.key,
    required this.resultsCount,
    required this.isLoading,
    required this.hasActiveSheetFilters,
    required this.onClearFilters,
  });

  final int resultsCount;
  final bool isLoading;
  final bool hasActiveSheetFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color accentColor = isDark
        ? const Color(0xFFC79A63)
        : const Color(0xFFB98552);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '$resultsCount result${resultsCount == 1 ? '' : 's'}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (hasActiveSheetFilters)
          const _SmallPill(label: 'Filtered'),
        if (hasActiveSheetFilters)
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onClearFilters,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(.10),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: accentColor.withOpacity(.18)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.close_rounded, size: 15, color: accentColor),
                  const SizedBox(width: 4),
                  Text(
                    'Clear',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (isLoading)
          const _SmallPill(label: 'Updating...'),
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.primary.withOpacity(.18)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}