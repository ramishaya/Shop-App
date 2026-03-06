import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/core/utils/theme/theme_cubit.dart';
import 'package:shop_app/features/shops/presentation/view_models/shops_cubit/shops_cubit.dart';
import 'package:shop_app/features/shops/presentation/view_models/shops_cubit/shops_state.dart';
import 'package:shop_app/features/shops/presentation/views/widgets/home_failure_view.dart';
import 'package:shop_app/features/shops/presentation/views/widgets/home_header_section.dart';
import 'package:shop_app/features/shops/presentation/views/widgets/home_loading_view.dart';
import 'package:shop_app/features/shops/presentation/views/widgets/home_no_results_view.dart';
import 'package:shop_app/features/shops/presentation/views/widgets/home_summary_row.dart';
import 'package:shop_app/features/shops/presentation/views/widgets/shop_card.dart';
import 'package:shop_app/features/shops/presentation/views/widgets/shops_filters_bottom_sheet.dart';
import 'package:shop_app/features/shops/presentation/views/widgets/shops_search_field.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<ShopsCubit>().state.searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFiltersBottomSheet() {
    final shopsCubit = context.read<ShopsCubit>();

    FocusManager.instance.primaryFocus?.unfocus();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: shopsCubit,
        child: const ShopsFiltersBottomSheet(),
      ),
    );
  }

  Future<void> _onRefresh() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await context.read<ShopsCubit>().fetchShops(
      showLoading: true,
      clearOldData: true,
    );
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() {});
    context.read<ShopsCubit>().onSearchChanged('');
    FocusManager.instance.primaryFocus?.unfocus();
  }

  String _buildNoResultsSubtitle(ShopsState state) {
    if (state.hasSearchQuery && state.hasActiveSheetFilters) {
      return 'Try another search term or reset the selected filters.';
    }

    if (state.hasSearchQuery) {
      return 'Try another search term.';
    }

    if (state.hasActiveSheetFilters) {
      return 'No shops match the selected filters.';
    }

    return 'No shops are available right now.';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopsCubit, ShopsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.isFailure &&
          current.hasData,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: SafeArea(
            child: BlocBuilder<ShopsCubit, ShopsState>(
              builder: (context, state) {
                final cubit = context.read<ShopsCubit>();

                if (state.isLoading && !state.hasData) {
                  return const HomeLoadingView();
                }

                if (state.isFailure && !state.hasData) {
                  return HomeFailureView(
                    message: state.errorMessage,
                    onRetry: cubit.retry,
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                        children: [
                          HomeHeaderSection(
                            title: 'Discover Stores',
                            subtitle: 'Find nearby shops, search quickly!',
                            searchField: ShopsSearchField(
                              controller: _searchController,
                              showClearButton: _searchController.text
                                  .trim()
                                  .isNotEmpty,
                              hintText: 'Search shops',
                              onChanged: (value) {
                                setState(() {});
                                cubit.onSearchChanged(value);
                              },
                              onClear: _onClearSearch,
                            ),
                            onFilterTap: _showFiltersBottomSheet,
                            hasActiveFilters: state.hasActiveSheetFilters,
                            isDarkMode: context.watch<ThemeCubit>().isDark,
                            onThemeToggle: () {
                              context.read<ThemeCubit>().toggleTheme();
                            },
                          ),
                          const SizedBox(height: 18),
                          HomeSummaryRow(
                            resultsCount: state.visibleShops.length,
                            isLoading: state.isLoading,
                            hasActiveSheetFilters: state.hasActiveSheetFilters,
                            onClearFilters: cubit.clearSheetFilters,
                          ),
                          if (state.isLoading && state.hasData) ...[
                            const SizedBox(height: 12),
                            const LinearProgressIndicator(minHeight: 3),
                          ],
                          const SizedBox(height: 16),
                          if (state.hasNoResults)
                            HomeNoResultsView(
                              title: 'No shops found',
                              subtitle: _buildNoResultsSubtitle(state),
                              onClear: () {
                                _searchController.clear();
                                setState(() {});
                                cubit.clearFilters();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              clearButtonText: 'Reset search & filters',
                            )
                          else
                            ...List.generate(
                              state.visibleShops.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == state.visibleShops.length - 1
                                      ? 0
                                      : 14,
                                ),
                                child: ShopCard(
                                  shop: state.visibleShops[index],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
