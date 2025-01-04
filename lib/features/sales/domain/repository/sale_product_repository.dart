import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/features/sales/domain/entity/sale_products_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SaleProductRepository {
  Future<Either<Failure, List<SaleProductsEntity>>> getSaleProducts();
}
