import 'package:equatable/equatable.dart';

import 'shop_model.dart';

class ShopsResponseModel extends Equatable {
  final List<ShopModel> result;

  const ShopsResponseModel({
    required this.result,
  });

  const ShopsResponseModel.empty() : result = const [];

  factory ShopsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['result'];

    if (rawList is! List) {
      return const ShopsResponseModel.empty();
    }

    return ShopsResponseModel(
      result: rawList
          .whereType<Map<String, dynamic>>()
          .map(ShopModel.fromJson)
          .toList(growable: false),
    );
  }

  ShopsResponseModel copyWith({
    List<ShopModel>? result,
  }) {
    return ShopsResponseModel(
      result: result ?? this.result,
    );
  }

  List<ShopModel> get enabledShops =>
      result.where((shop) => shop.isDisplayable).toList(growable: false);

  Map<String, dynamic> toJson() {
    return {
      'result': result.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [result];
}