import 'package:compareitr/core/common/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.categoryName,
    required super.categoryUrl,
    required super.shopName,
    required super.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryName: json['categoryName'] ?? '',
      categoryUrl: json['categoryUrl'] ?? '',
      shopName: json['shopName'] ?? '',
      id: json['id'] ?? '',
    );
  }
}
