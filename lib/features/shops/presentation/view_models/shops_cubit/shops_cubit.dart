import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/shop_model.dart';
import '../../../data/repos/shops_repo.dart';
import 'shops_state.dart';

class ShopsCubit extends Cubit<ShopsState> {
  final ShopsRepo shopsRepo;

  Timer? _searchDebounce;

  ShopsCubit({required this.shopsRepo}) : super(const ShopsState.initial());

  Future<void> fetchShops({
    bool showLoading = true,
    bool clearOldData = false,
  }) async {
    _searchDebounce?.cancel();

    if (showLoading) {
      emit(
        state.copyWith(
          status: ShopsStatus.loading,
          allShops: clearOldData ? [] : state.allShops,
          visibleShops: clearOldData ? [] : state.visibleShops,
          clearErrorMessage: true,
        ),
      );
    }

    final result = await shopsRepo.fetchShops();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ShopsStatus.failure,
            errorMessage: failure.errMessage,
          ),
        );
      },
      (response) {
        final source = response.enabledShops;
        final filtered = _applyViewRules(
          shops: source,
          query: state.searchQuery,
          openOnly: state.openOnly,
          sortOption: state.sortOption,
        );

        emit(
          state.copyWith(
            status: ShopsStatus.success,
            allShops: source,
            visibleShops: filtered,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  void onSearchChanged(String value) {
    _searchDebounce?.cancel();

    emit(state.copyWith(searchQuery: value));

    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      _refreshVisibleShops,
    );
  }

  void setSortOption(ShopsSortOption option) {
    emit(state.copyWith(sortOption: option));

    _refreshVisibleShops();
  }

  void toggleOpenOnly([bool? value]) {
    emit(state.copyWith(openOnly: value ?? !state.openOnly));

    _refreshVisibleShops();
  }

  void clearFilters() {
    _searchDebounce?.cancel();

    emit(
      state.copyWith(
        searchQuery: '',
        openOnly: false,
        sortOption: ShopsSortOption.none,
      ),
    );

    _refreshVisibleShops();
  }

  Future<void> retry() async {
    await fetchShops();
  }

  void _refreshVisibleShops() {
    final filtered = _applyViewRules(
      shops: state.allShops,
      query: state.searchQuery,
      openOnly: state.openOnly,
      sortOption: state.sortOption,
    );

    emit(
      state.copyWith(
        status: ShopsStatus.success,
        visibleShops: filtered,
        clearErrorMessage: true,
      ),
    );
  }

  List<ShopModel> _applyViewRules({
    required List<ShopModel> shops,
    required String query,
    required bool openOnly,
    required ShopsSortOption sortOption,
  }) {
    final filtered = shops.where((shop) {
      if (!shop.isDisplayable) return false;
      if (openOnly && !shop.isOpen) return false;
      if (!shop.matchesQuery(query)) return false;
      return true;
    }).toList();

    switch (sortOption) {
      case ShopsSortOption.etaAscending:
        filtered.sort((a, b) {
          final etaCompare = a.estimatedDeliveryMinutes.compareTo(
            b.estimatedDeliveryMinutes,
          );
          if (etaCompare != 0) return etaCompare;

          return a.shopName.en.toLowerCase().compareTo(
            b.shopName.en.toLowerCase(),
          );
        });
        break;

      case ShopsSortOption.minimumOrderAscending:
        filtered.sort((a, b) {
          final minOrderCompare = a.minimumOrder.amountAsDouble.compareTo(
            b.minimumOrder.amountAsDouble,
          );
          if (minOrderCompare != 0) return minOrderCompare;

          return a.shopName.en.toLowerCase().compareTo(
            b.shopName.en.toLowerCase(),
          );
        });
        break;

      case ShopsSortOption.none:
        break;
    }

    return List<ShopModel>.unmodifiable(filtered);
  }

  void clearSheetFilters() {
    emit(state.copyWith(openOnly: false, sortOption: ShopsSortOption.none));

    _refreshVisibleShops();
  }

  void toggleEtaSort(bool enabled) {
    emit(
      state.copyWith(
        sortOption: enabled
            ? ShopsSortOption.etaAscending
            : (state.sortOption == ShopsSortOption.etaAscending
                  ? ShopsSortOption.none
                  : state.sortOption),
      ),
    );

    _refreshVisibleShops();
  }

  void toggleMinimumOrderSort(bool enabled) {
    emit(
      state.copyWith(
        sortOption: enabled
            ? ShopsSortOption.minimumOrderAscending
            : (state.sortOption == ShopsSortOption.minimumOrderAscending
                  ? ShopsSortOption.none
                  : state.sortOption),
      ),
    );

    _refreshVisibleShops();
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
