import 'package:compareitr/features/order/domain/entities/order_entity.dart';
import 'package:equatable/equatable.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required String orderId,
    required String userId,
    required List<OrderItemModel> items,
    required double subtotal,
    required double deliveryFee,
    required double totalAmount,
    required DateTime orderDate,
    required String deliveryAddress,
    required String orderStatus,
  }) : super(
          orderId: orderId,
          userId: userId,
          items: items,
          subtotal: subtotal,
          deliveryFee: deliveryFee,
          totalAmount: totalAmount,
          orderDate: orderDate,
          deliveryAddress: deliveryAddress,
          orderStatus: orderStatus,
        );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      deliveryAddress: json['deliveryAddress'],
      orderStatus: json['orderStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'orderStatus': orderStatus,
    };
  }
}

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required String productId,
    required String itemName,
    required String shopName,
    required String imageUrl,
    required double price,
    required int quantity,
  }) : super(
          productId: productId,
          itemName: itemName,
          shopName: shopName,
          imageUrl: imageUrl,
          price: price,
          quantity: quantity,
        );

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'],
      itemName: json['itemName'],
      shopName: json['shopName'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'itemName': itemName,
      'shopName': shopName,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
}
