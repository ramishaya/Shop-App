import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/features/shops/presentation/view_models/shops_cubit/shops_cubit.dart';
import 'package:shop_app/features/shops/presentation/view_models/shops_cubit/shops_state.dart';

class ShopsFiltersBottomSheet extends StatelessWidget {
  const ShopsFiltersBottomSheet({super.key});

  bool _isArabic(BuildContext context) => Localizations.localeOf(
    context,
  ).languageCode.toLowerCase().startsWith('ar');

  String _tr(BuildContext context, {required String en, required String ar}) {
    return _isArabic(context) ? ar : en;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Color accentColor = isDark
        ? const Color(0xFFC79A63)
        : const Color(0xFFB98552);

    return BlocBuilder<ShopsCubit, ShopsState>(
      builder: (context, state) {
        final cubit = context.read<ShopsCubit>();

        return SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 5,
                      decoration: BoxDecoration(
                        color: theme.dividerColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _tr(
                            context,
                            en: 'Filters & Sorting',
                            ar: 'الفلاتر والترتيب',
                          ),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.3,
                          ),
                        ),
                      ),
                      if (state.hasActiveSheetFilters)
                        OutlinedButton.icon(
                          onPressed: cubit.clearSheetFilters,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: accentColor.withOpacity(.28),
                            ),
                            foregroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(
                            Icons.filter_alt_off_rounded,
                            size: 16,
                          ),
                          label: Text(
                            _tr(
                              context,
                              en: 'Clear filters',
                              ar: 'مسح الفلاتر',
                            ),
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _tr(
                      context,
                      en: 'Refine the list with simple sorting and availability options.',
                      ar: 'قم بتحسين القائمة بخيارات بسيطة للترتيب والتوفر.',
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _MinimalFilterTile(
                    title: _tr(
                      context,
                      en: 'Sort by ETA',
                      ar: 'الترتيب حسب وقت التوصيل',
                    ),
                    subtitle: _tr(
                      context,
                      en: 'Faster first',
                      ar: 'الأسرع أولاً',
                    ),
                    value: state.isEtaSortSelected,
                    onChanged: cubit.toggleEtaSort,
                    accentColor: accentColor,
                  ),
                  const SizedBox(height: 10),
                  _MinimalFilterTile(
                    title: _tr(
                      context,
                      en: 'Sort by minimum order',
                      ar: 'الترتيب حسب الحد الأدنى',
                    ),
                    subtitle: _tr(
                      context,
                      en: 'Lower first',
                      ar: 'الأقل أولاً',
                    ),
                    value: state.isMinimumOrderSortSelected,
                    onChanged: cubit.toggleMinimumOrderSort,
                    accentColor: accentColor,
                  ),
                  const SizedBox(height: 10),
                  _MinimalAvailabilityTile(
                    title: _tr(context, en: 'Availability', ar: 'التوفر'),
                    subtitle: _tr(
                      context,
                      en: 'All or open shops only',
                      ar: 'الكل أو المتاجر المفتوحة فقط',
                    ),
                    isOpenOnly: state.openOnly,
                    allLabel: _tr(context, en: 'All', ar: 'الكل'),
                    openOnlyLabel: _tr(
                      context,
                      en: 'Open only',
                      ar: 'المفتوح فقط',
                    ),
                    onChanged: (value) => cubit.toggleOpenOnly(value),
                    accentColor: accentColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MinimalFilterTile extends StatelessWidget {
  const _MinimalFilterTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.cardTheme.color ?? theme.colorScheme.surface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(.8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Transform.scale(
            scale: .92,
            child: CupertinoSwitch(
              value: value,
              activeTrackColor: accentColor,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _MinimalAvailabilityTile extends StatelessWidget {
  const _MinimalAvailabilityTile({
    required this.title,
    required this.subtitle,
    required this.isOpenOnly,
    required this.allLabel,
    required this.openOnlyLabel,
    required this.onChanged,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final bool isOpenOnly;
  final String allLabel;
  final String openOnlyLabel;
  final ValueChanged<bool> onChanged;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.cardTheme.color ?? theme.colorScheme.surface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          _SimpleSegmentedControl(
            isOpenOnly: isOpenOnly,
            allLabel: allLabel,
            openOnlyLabel: openOnlyLabel,
            onChanged: onChanged,
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }
}

class _SimpleSegmentedControl extends StatelessWidget {
  const _SimpleSegmentedControl({
    required this.isOpenOnly,
    required this.allLabel,
    required this.openOnlyLabel,
    required this.onChanged,
    required this.accentColor,
  });

  final bool isOpenOnly;
  final String allLabel;
  final String openOnlyLabel;
  final ValueChanged<bool> onChanged;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? Colors.white.withOpacity(.04)
        : Colors.black.withOpacity(.035);

    final selectedBg = accentColor.withOpacity(isDark ? .18 : .10);

    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SimpleSegmentItem(
              label: allLabel,
              isSelected: !isOpenOnly,
              selectedColor: accentColor,
              selectedBg: selectedBg,
              onTap: () => onChanged(false),
            ),
          ),
          Expanded(
            child: _SimpleSegmentItem(
              label: openOnlyLabel,
              isSelected: isOpenOnly,
              selectedColor: accentColor,
              selectedBg: selectedBg,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleSegmentItem extends StatelessWidget {
  const _SimpleSegmentItem({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.selectedBg,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color selectedBg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected ? selectedBg : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? selectedColor
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
