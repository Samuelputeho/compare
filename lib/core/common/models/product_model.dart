import 'package:compareitr/core/common/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.measure,
    required super.imageUrl,
    required super.price,
    required super.salePrice,
    required super.description,
    required super.shopName,
    required super.category,
    required super.subCategory,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      measure: json['measure'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: json['price'] ?? 0.0,
      salePrice: json['salePrice'] ?? 0.0,
      description: json['description'] ?? '',
      shopName: json['shopName'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
    );
  }
}
