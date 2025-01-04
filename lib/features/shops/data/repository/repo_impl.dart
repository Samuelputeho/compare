import 'package:compareitr/core/common/entities/category_entity.dart';
import 'package:compareitr/core/common/entities/product_entity.dart';
import 'package:compareitr/core/common/models/product_model.dart';
import 'package:compareitr/core/common/models/shop_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repository/repo.dart';
import '../datasources/shops_remote_datasource.dart';

class ShopsRepositoryImpl implements ShopsRepository {
  final ShopsRemoteDataSource remoteDataSource;

  ShopsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ShopModel>>> getAllShops() async {
    try {
      final shops = await remoteDataSource.getAllShops();
      return right(shops);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final categories = await remoteDataSource.getAllCategories();
      return right(categories);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    try {
      final products = await remoteDataSource.getAllProducts();
      return right(products);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
