import 'package:dartz/dartz.dart';
import 'package:shop_app/core/errors/faliures.dart';

import '../models/shops_response_model.dart';

abstract class ShopsRepo {
  Future<Either<Failure, ShopsResponseModel>> fetchShops();
}