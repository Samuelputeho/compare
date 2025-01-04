import 'package:compareitr/features/sales/domain/entity/sale_products_entity.dart';

class SaleProductModel extends SaleProductsEntity {
  final String? name;
  final String? image;
  final double? price;
  final double? save;
  final String? description;
  final double? oldprice;
  final String? storeName;
  final String? measure;
  final DateTime? startDate;
  final DateTime? endDate;

  SaleProductModel({
    this.name,
    this.image,
    this.price,
    this.save,
    this.description,
    this.oldprice,
    this.storeName,
    this.measure,
    this.startDate,
    this.endDate,
  }) : super(
          image: image ?? '',
          measure: measure ?? '', // Default empty string if null
          storeName: storeName ?? '', // Default empty string if null
          description: description ?? '',
          oldprice: oldprice ?? 0.0, // Default to 0.0 if null
          startDate: startDate ?? DateTime.now(), // Default to current date
          endDate: endDate ?? DateTime.now(),
        );

  /// Factory constructor for creating a SaleProductModel from JSON
  factory SaleProductModel.fromJson(Map<String, dynamic> json) {
    return SaleProductModel(
      name: json['name'] as String?,
      image: json['image'] as String?,
      price: (json['price'] as num?)?.toDouble(), // Handle numeric conversion
      save: (json['save'] as num?)?.toDouble(),
      description: json['description'] as String?,
      oldprice: (json['oldprice'] as num?)?.toDouble(),
      storeName: json['storeName'] as String?,
      measure: json['measure'] as String?,
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }
}
