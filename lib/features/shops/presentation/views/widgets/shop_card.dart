import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop_app/core/utils/constants/assets_data.dart';
import 'package:shop_app/core/utils/widgets/cached_network_image.dart';
import 'package:shop_app/features/shops/data/models/shop_model.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({
    super.key,
    required this.shop,
  });

  final ShopModel shop;

  bool _isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode.toLowerCase().startsWith('ar');

  String _tr(BuildContext context, {required String en, required String ar}) {
    return _isArabic(context) ? ar : en;
  }

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Color accentColor = isDark
        ? const Color(0xFFC79A63)
        : const Color(0xFFB98552);

    final title = shop.localizedName(localeCode);
    final description = shop.localizedDescription(localeCode);

    final minimumOrderText = shop.minimumOrder.formatted.trim().isEmpty
        ? _tr(context, en: 'N/A', ar: 'غير متوفر')
        : shop.minimumOrder.formatted;

    final etaText = shop.estimatedDeliveryTime.trim().isEmpty
        ? _tr(context, en: 'N/A', ar: 'غير متوفر')
        : shop.estimatedDeliveryTime;

    final locationText = shop.locationText.trim().isEmpty
        ? _tr(context, en: 'Location unavailable', ar: 'الموقع غير متوفر')
        : shop.locationText;

    final categoryText = shop.categoryType.trim().isEmpty
        ? _tr(context, en: 'Store', ar: 'متجر')
        : shop.categoryType;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
      
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? .16 : .05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardImageSection(
            shop: shop,
            categoryText: categoryText,
            openText: _tr(context, en: 'Open', ar: 'مفتوح'),
            closedText: _tr(context, en: 'Closed', ar: 'مغلق'),
            accentColor: accentColor,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty
                      ? _tr(context, en: 'Unnamed shop', ar: 'متجر بدون اسم')
                      : title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.4,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description.isEmpty
                      ? _tr(
                          context,
                          en: 'No description available',
                          ar: 'لا يوجد وصف متاح',
                        )
                      : description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.45,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _MinimalStatTile(
                        icon: Iconsax.clock,
                        value: etaText,
                        subtitle: _tr(
                          context,
                          en: 'Delivery time',
                          ar: 'وقت التوصيل',
                        ),
                        accentColor: accentColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MinimalStatTile(
                        icon: Iconsax.money,
                        value: minimumOrderText,
                        subtitle: _tr(
                          context,
                          en: 'Minimum order',
                          ar: 'الحد الأدنى',
                        ),
                        accentColor: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _MinimalLocationTile(
                  icon: Iconsax.location,
                  value: locationText,
                  subtitle: _tr(
                    context,
                    en: 'Location',
                    ar: 'الموقع',
                  ),
                  accentColor: accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardImageSection extends StatelessWidget {
  const _CardImageSection({
    required this.shop,
    required this.categoryText,
    required this.openText,
    required this.closedText,
    required this.accentColor,
  });

  final ShopModel shop;
  final String categoryText;
  final String openText;
  final String closedText;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9.4,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (shop.imageUrl.trim().isNotEmpty)
            CachedNetworkImg(
              width: double.infinity,
              height: double.infinity,
              img: shop.imageUrl,
              placeHolder: AssetsData.placeHolderImg,
            )
          else
            Image.asset(
              AssetsData.placeHolderImg,
              fit: BoxFit.cover,
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.08),
                  Colors.transparent,
                  Colors.black.withOpacity(.42),
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
          PositionedDirectional(
            top: 14,
            start: 14,
            child: _AvailabilityBadge(
              isOpen: shop.isOpen,
              openText: openText,
              closedText: closedText,
            ),
          ),
          PositionedDirectional(
            bottom: 14,
            start: 14,
            child: _CategoryPill(
              label: categoryText,
              accentColor: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({
    required this.isOpen,
    required this.openText,
    required this.closedText,
  });

  final bool isOpen;
  final String openText;
  final String closedText;

  @override
  Widget build(BuildContext context) {
    final Color dotColor = isOpen
        ? const Color(0xFF23C16B)
        : const Color(0xFFFF5A5F);

    final Color borderColor = isOpen
        ? const Color(0xFF23C16B).withOpacity(.50)
        : const Color(0xFFFF5A5F).withOpacity(.45);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.34),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withOpacity(.55),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isOpen ? openText : closedText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: .1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.accentColor,
  });

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 160),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: accentColor.withOpacity(.32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(.18),
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class _MinimalStatTile extends StatelessWidget {
  const _MinimalStatTile({
    required this.icon,
    required this.value,
    required this.subtitle,
    required this.accentColor,
  });

  final IconData icon;
  final String value;
  final String subtitle;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accentColor.withOpacity(.14),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 17,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.2,
                    height: 1.0,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MinimalLocationTile extends StatelessWidget {
  const _MinimalLocationTile({
    required this.icon,
    required this.value,
    required this.subtitle,
    required this.accentColor,
  });

  final IconData icon;
  final String value;
  final String subtitle;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color bgColor =
        (colorScheme.surfaceContainerHighest).withOpacity(.35);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accentColor.withOpacity(.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(.10),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 16,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$subtitle: ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}