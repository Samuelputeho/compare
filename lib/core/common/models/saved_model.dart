import 'package:compareitr/core/common/entities/saved_entity.dart';

class SavedModel extends SavedEntity {
  SavedModel({
    String? id,
    required String name,
    required String image,
    required String measure,
    required String shopName,
    required String savedId,
    required double price,
  }) : super(
          id: id ?? '',
          name: name,
          image: image,
          measure: measure,
          shopName: shopName,
          savedId: savedId,
          price: price,
        );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'measure': measure,
      'shopName': shopName,
      'savedId': savedId,
      'price': price,
    };
  }

  factory SavedModel.fromJson(Map<String, dynamic> json) {
    return SavedModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      measure: json['measure'] as String,
      shopName: json['shopName'] as String,
      savedId: json['savedId'] as String,
      price: double.parse(json['price'].toString()),
    );
  }
}
