import 'package:equatable/equatable.dart';

import '../../../data/models/shop_model.dart';

enum ShopsStatus { initial, loading, success, failure }

enum ShopsSortOption { none, etaAscending, minimumOrderAscending }

class ShopsState extends Equatable {
  final ShopsStatus status;
  final List<ShopModel> allShops;
  final List<ShopModel> visibleShops;
  final String searchQuery;
  final bool openOnly;
  final ShopsSortOption sortOption;
  final String errorMessage;

  const ShopsState({
    required this.status,
    required this.allShops,
    required this.visibleShops,
    required this.searchQuery,
    required this.openOnly,
    required this.sortOption,
    required this.errorMessage,
  });

  const ShopsState.initial()
      : status = ShopsStatus.initial,
        allShops = const [],
        visibleShops = const [],
        searchQuery = '',
        openOnly = false,
        sortOption = ShopsSortOption.none,
        errorMessage = '';

  ShopsState copyWith({
    ShopsStatus? status,
    List<ShopModel>? allShops,
    List<ShopModel>? visibleShops,
    String? searchQuery,
    bool? openOnly,
    ShopsSortOption? sortOption,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ShopsState(
      status: status ?? this.status,
      allShops: allShops ?? this.allShops,
      visibleShops: visibleShops ?? this.visibleShops,
      searchQuery: searchQuery ?? this.searchQuery,
      openOnly: openOnly ?? this.openOnly,
      sortOption: sortOption ?? this.sortOption,
      errorMessage: clearErrorMessage ? '' : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isInitial => status == ShopsStatus.initial;
  bool get isLoading => status == ShopsStatus.loading;
  bool get isSuccess => status == ShopsStatus.success;
  bool get isFailure => status == ShopsStatus.failure;

  bool get hasData => allShops.isNotEmpty;
  bool get hasVisibleData => visibleShops.isNotEmpty;
  bool get hasNoResults => isSuccess && visibleShops.isEmpty;

  bool get hasSearchQuery => searchQuery.trim().isNotEmpty;

  /// Only bottom-sheet filters/sorts
  bool get hasActiveSheetFilters =>
      openOnly || sortOption != ShopsSortOption.none;

  /// Full active controls state: search + sheet filters
  bool get hasActiveSearchOrFilters =>
      hasSearchQuery || hasActiveSheetFilters;

  bool get isEtaSortSelected => sortOption == ShopsSortOption.etaAscending;
  bool get isMinimumOrderSortSelected =>
      sortOption == ShopsSortOption.minimumOrderAscending;

  @override
  List<Object?> get props => [
        status,
        allShops,
        visibleShops,
        searchQuery,
        openOnly,
        sortOption,
        errorMessage,
      ];
}