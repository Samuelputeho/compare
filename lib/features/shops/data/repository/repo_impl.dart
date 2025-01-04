import 'package:compareitr/core/common/entities/category_entity.dart';
import 'package:compareitr/core/common/models/category_model.dart';
import 'package:compareitr/core/common/models/product_model.dart';
import 'package:compareitr/core/common/models/shop_model.dart';
import 'package:compareitr/core/common/network/network_connection.dart';
import 'package:compareitr/features/shops/data/datasources/shops_local_datasource.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repository/repo.dart';
import '../datasources/shops_remote_datasource.dart';

class ShopsRepositoryImpl implements ShopsRepository {
  final ShopsRemoteDataSource remoteDataSource;

  ShopsRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, List<ShopModel>>> getAllShops() async {
    try {
      // Fetch shops from the remote data source (no internet check)
      final shops = await remoteDataSource.getAllShops();
      print('Fetched shops from remote: $shops');
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
      // Fetch categories from the remote data source (no internet check)
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
      // Fetch products from the remote data source (no internet check)
      final products = await remoteDataSource.getAllProducts();
      return right(products);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
