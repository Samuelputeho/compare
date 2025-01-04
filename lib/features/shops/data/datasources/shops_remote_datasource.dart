import 'package:compareitr/core/common/models/category_model.dart';
import 'package:compareitr/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/models/product_model.dart';
import '../../../../core/common/models/shop_model.dart';
import '../../../../core/constants/app_const.dart';

abstract interface class ShopsRemoteDataSource {
  Future<List<ShopModel>> getAllShops();
  Future<List<CategoryModel>> getAllCategories();
  Future<List<ProductModel>> getAllProducts();
}

class ShopsRemoteDataSourceImpl implements ShopsRemoteDataSource {
  final SupabaseClient client;

  ShopsRemoteDataSourceImpl(this.client);

  @override
  Future<List<ShopModel>> getAllShops() async {
    try {
      final response = await client.from(AppConstants.shopCollection).select();
      return response.map((json) => ShopModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response =
          await client.from(AppConstants.categoryCollection).select('''
            *,
            ${AppConstants.productCollection}!inner (
              ${AppConstants.shopCollection}!inner (
                shopName
              )
            )
          ''');

      return response.map((json) {
        final shopName = json[AppConstants.productCollection][0]
            [AppConstants.shopCollection]['shopName'];

        final modifiedJson = {
          ...json,
          'shopName': shopName,
        };
        modifiedJson.remove(AppConstants.productCollection);

        return CategoryModel.fromJson(modifiedJson);
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response =
          await client.from(AppConstants.productCollection).select('''
            *,
            ${AppConstants.shopCollection}!inner (
              shopName
            ),
            ${AppConstants.categoryCollection}!inner (
              categoryName
            )
          ''').order('created_at');

      return response.map((json) {
        final modifiedJson = {
          ...json,
          'shopName': json[AppConstants.shopCollection]['shopName'],
          'category': json[AppConstants.categoryCollection]['categoryName'],
        };
        modifiedJson.remove(AppConstants.shopCollection);
        modifiedJson.remove(AppConstants.categoryCollection);

        return ProductModel.fromJson(modifiedJson);
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
