import 'package:compareitr/core/error/exceptions.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/features/sales/data/datasources/sale_products_data_source.dart';
import 'package:compareitr/features/sales/domain/entity/sale_card_entity.dart';
import 'package:compareitr/features/sales/domain/entity/sale_products_entity.dart';
import 'package:compareitr/features/sales/domain/repository/sale_product_repository.dart';
import 'package:fpdart/src/either.dart';

class SaleProductRepositoryImpl implements SaleProductRepository {
  final SaleProductRemoteDataSource remoteDataSource;

  SaleProductRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, List<SaleProductsEntity>>> getSaleProducts() async {
    try {
      final saleProducts = await remoteDataSource.getSaleProducts();

      // Convert RecentModel list to CartEntity list.
      final saleEntities = saleProducts.map((model) {
        return SaleProductsEntity(
          storeName: model.storeName,
          image: model.image,
          name: model.name,
          description: model.description,
          price: model.price,
          oldprice: model.oldprice,
          measure: model.measure,
          save: model.save,
          startDate: model.startDate,
          endDate: model.endDate,
        );
      }).toList();

      return right(saleEntities);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error: $e'));
    }
  }
}
