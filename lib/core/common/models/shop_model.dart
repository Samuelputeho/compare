import '../entities/shop_entity.dart';

class ShopModel extends ShopEntity {
  ShopModel({
    required super.shopName,
    required super.shopLogoUrl,
    required super.id,
  });

// from json
  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      shopName: json['shopName'] as String? ?? '',
      shopLogoUrl: json['shopLogoUrl'] as String? ?? '',
      id: json['id'] as String? ?? '',
    );
  }
}
