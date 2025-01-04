import 'package:compareitr/features/sales/domain/entity/sale_card_entity.dart';
import 'package:flutter/material.dart';

class SaleCardModel extends SaleCardEntity {
  final String? image;
  final String? storeName;
  final DateTime? startDate;
  final DateTime? endDate;

  SaleCardModel({
    this.image,
    this.storeName,
    this.startDate,
    this.endDate,
  }) : super(
          image: image ?? '',
          storeName: storeName ?? '',
          startDate: startDate ?? DateTime.now(),
          endDate: endDate ?? DateTime.now(),
        );

  factory SaleCardModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedStartDate;
    DateTime? parsedEndDate;

    // Attempt to parse startDate, logging if it fails
    if (json['startDate'] != null) {
      parsedStartDate = DateTime.tryParse(json['startDate']);
      if (parsedStartDate == null) {
        debugPrint('Error parsing startDate: ${json['startDate']}');
      }
    }

    // Attempt to parse endDate, logging if it fails
    if (json['endDate'] != null) {
      parsedEndDate = DateTime.tryParse(json['endDate']);
      if (parsedEndDate == null) {
        debugPrint('Error parsing endDate: ${json['endDate']}');
      }
    }

    // Check if the startDate and endDate are valid
    if (parsedStartDate == null || parsedEndDate == null) {
      debugPrint('Invalid date range for sale card: $json');
    }

    return SaleCardModel(
      image: json['image'] as String?,
      storeName: json['storeName'] as String?,
      startDate: parsedStartDate ?? DateTime.now(),
      endDate: parsedEndDate ?? DateTime.now(),
    );
  }
}
