import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark
        ? Colors.white.withOpacity(.06)
        : Colors.black.withOpacity(.05);

    final highlightColor = isDark
        ? Colors.white.withOpacity(.12)
        : Colors.white.withOpacity(.75);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: const Duration(milliseconds: 1200),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            children: const [
              _LoadingHeaderSection(),
              SizedBox(height: 18),
              _LoadingSummaryRow(),
              SizedBox(height: 16),
              _LoadingShopCard(),
              SizedBox(height: 14),
              _LoadingShopCard(),
              SizedBox(height: 14),
              _LoadingShopCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingHeaderSection extends StatelessWidget {
  const _LoadingHeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(width: 230, height: 26, radius: 12),
                  SizedBox(height: 10),
                  _ShimmerBox(width: 180, height: 26, radius: 12),
                ],
              ),
            ),
            SizedBox(width: 12),
            _ShimmerCircle(size: 43),
          ],
        ),
        const SizedBox(height: 12),
        const _ShimmerBox(width: 260, height: 16, radius: 10),
        const SizedBox(height: 8),
        const _ShimmerBox(width: 180, height: 16, radius: 10),
        const SizedBox(height: 18),
        Row(
          children: const [
            Expanded(
              child: _ShimmerBox(
                width: double.infinity,
                height: 54,
                radius: 27,
              ),
            ),
            SizedBox(width: 12),
            _ShimmerCircle(size: 43),
          ],
        ),
      ],
    );
  }
}

class _LoadingSummaryRow extends StatelessWidget {
  const _LoadingSummaryRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _ShimmerBox(width: 110, height: 18, radius: 10),
      ],
    );
  }
}

class _LoadingShopCard extends StatelessWidget {
  const _LoadingShopCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Theme.of(context).colorScheme.surface,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _ShimmerBox(width: double.infinity, height: 210, radius: 0),
          Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 240, height: 24, radius: 12),
                SizedBox(height: 10),
                _ShimmerBox(width: double.infinity, height: 16, radius: 10),
                SizedBox(height: 8),
                _ShimmerBox(width: 210, height: 16, radius: 10),
                SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _ShimmerBox(
                        width: double.infinity,
                        height: 74,
                        radius: 18,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _ShimmerBox(
                        width: double.infinity,
                        height: 74,
                        radius: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _ShimmerBox(width: double.infinity, height: 58, radius: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class _ShimmerCircle extends StatelessWidget {
  const _ShimmerCircle({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return _ShimmerBox(
      width: size,
      height: size,
      radius: size / 2,
    );
  }
}