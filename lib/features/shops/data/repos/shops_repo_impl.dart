import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_app/core/errors/faliures.dart';
import 'package:shop_app/core/utils/api/api_service.dart';

import '../models/shops_response_model.dart';
import 'shops_repo.dart';

class ShopsRepoImpl implements ShopsRepo {
  final ApiService apiService;

  static const String _endpoint = 'shop/test/find/all/shop';
  static const String _secretKey = String.fromEnvironment('SHOP_SECRET_KEY');

  ShopsRepoImpl({required this.apiService});

  @override
  Future<Either<Failure, ShopsResponseModel>> fetchShops() async {
    try {
      if (_secretKey.trim().isEmpty) {
        return Left(
          ServerFailure(
            'Missing SHOP_SECRET_KEY. Run the app with --dart-define=SHOP_SECRET_KEY',
          ),
        );
      }

      final response = await apiService.get(
        endpoint: _endpoint,
        headers: {'secretKey': _secretKey, 'Accept': 'application/json'},
        queryParameters: {'deviceKind': _resolveDeviceKind()},
      );

      if (response is! Map<String, dynamic>) {
        return Left(ServerFailure('Invalid server response format'));
      }

      final shopsResponse = ShopsResponseModel.fromJson(response);
      return Right(shopsResponse);
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  String _resolveDeviceKind() {
    if (kIsWeb) return 'web';

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      default:
        return 'android';
    }
  }
}
