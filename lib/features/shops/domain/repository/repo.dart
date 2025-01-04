import 'package:compareitr/core/common/entities/category_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/product_entity.dart';
import '../../../../core/common/entities/shop_entity.dart';
import '../../../../core/error/failures.dart';

abstract interface class ShopsRepository {
  Future<Either<Failure, List<ShopEntity>>> getAllShops();
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
  Future<Either<Failure, List<ProductEntity>>> getAllProducts();
}
