import 'package:compareitr/core/common/models/category_model.dart';
import 'package:compareitr/core/common/models/product_model.dart';
import 'package:compareitr/core/common/models/shop_model.dart';
import 'package:hive/hive.dart';

abstract interface class ShopsLocalDataSource {
  void uploadLocalShops({required List<ShopModel> shops});
  void uploadLocalCategories({required List<CategoryModel> categories});
  void uploadLocalProducts({required List<ProductModel> products});
  List<ShopModel> loadShops();
  List<CategoryModel> loadCategories();
  List<ProductModel> loadProducts();
}

class ShopsLocalDataSourceImpl implements ShopsLocalDataSource {
  final Box box;

  ShopsLocalDataSourceImpl(this.box);

  @override
  List<CategoryModel> loadCategories() {
    List<CategoryModel> categories = [];
    for (int i = 0; i < box.length; i++) {
      final category = box.get('category_$i');  // Using meaningful keys
      if (category != null && category is Map<String, dynamic>) {
        categories.add(CategoryModel.fromJson(category));
      }
    }
    return categories;
  }

  @override
  List<ProductModel> loadProducts() {
    List<ProductModel> products = [];
    for (int i = 0; i < box.length; i++) {
      final product = box.get('product_$i');  // Using meaningful keys
      if (product != null && product is Map<String, dynamic>) {
        products.add(ProductModel.fromJson(product));
      }
    }
    return products;
  }

  @override
  List<ShopModel> loadShops() {
    List<ShopModel> shops = [];
    for (int i = 0; i < box.length; i++) {
      final shop = box.get('shop_$i');  // Using meaningful keys
      if (shop != null && shop is Map<String, dynamic>) {
        shops.add(ShopModel.fromJson(shop));
      }
    }
    print('Loaded shops from local storage: $shops');
    return shops;
  }

  @override
  void uploadLocalCategories({required List<CategoryModel> categories}) {
    Map<String, dynamic> categoryData = {};
    for (int i = 0; i < categories.length; i++) {
      categoryData['category_$i'] = {
        'categoryName': categories[i].categoryName,
        'categoryUrl': categories[i].categoryUrl,
        'shopName': categories[i].shopName,
        'id': categories[i].id,
      };
    }
    box.putAll(categoryData);  // Batch write
  }

  @override
  void uploadLocalProducts({required List<ProductModel> products}) {
    Map<String, dynamic> productData = {};
    for (int i = 0; i < products.length; i++) {
      productData['product_$i'] = {
        'id': products[i].id,
        'name': products[i].name,
        'measure': products[i].measure,
        'imageUrl': products[i].imageUrl,
        'price': products[i].price,
        'salePrice': products[i].salePrice,
        'description': products[i].description,
        'shopName': products[i].shopName,
        'category': products[i].category,
        'subCategory': products[i].subCategory,
      };
    }
    box.putAll(productData);  // Batch write
  }

  @override
  void uploadLocalShops({required List<ShopModel> shops}) {
    print('Uploading shops to local storage: $shops');
    Map<String, dynamic> shopData = {};
    for (int i = 0; i < shops.length; i++) {
      shopData['shop_$i'] = {
        'shopName': shops[i].shopName,
        'shopLogoUrl': shops[i].shopLogoUrl,
        'id': shops[i].id,
      };
    }
    box.putAll(shopData);  // Batch write
    print('Shops uploaded to local storage');
  }
}
