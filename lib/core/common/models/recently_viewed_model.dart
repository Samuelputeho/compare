import 'package:compareitr/core/common/entities/recently_viewed_entity.dart';

class RecentlyViewedModel extends RecentlyViewedEntity {
  RecentlyViewedModel({
    String? id,
    required String name,
    required String image,
    required String measure,
    required String shopName,
    required String recentId,
    required double price,
  }) : super(
          id: id ?? '',
          name: name,
          image: image,
          measure: measure,
          shopName: shopName,
          recentId: recentId,
          price: price,
        );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'measure': measure,
      'shopName': shopName,
      'recentId': recentId,
      'price': price,
    };
  }

  factory RecentlyViewedModel.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      measure: json['measure'] as String,
      shopName: json['shopName'] as String,
      recentId: json['recentId'] as String,
      price: double.parse(json['price'].toString()),
    );
  }
}
