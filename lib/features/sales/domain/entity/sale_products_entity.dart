// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SaleProductsEntity {
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

  SaleProductsEntity({
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
  });

}