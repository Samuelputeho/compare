import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String orderId;
  final String userId;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final DateTime orderDate;
  final String deliveryAddress;
  final String orderStatus; // 'pending', 'processing', 'delivered', etc.

  const OrderEntity({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.orderDate,
    required this.deliveryAddress,
    required this.orderStatus,
  });

  @override
  List<Object?> get props => [
        orderId,
        userId,
        items,
        subtotal,
        deliveryFee,
        totalAmount,
        orderDate,
        deliveryAddress,
        orderStatus,
      ];
}

class OrderItemEntity extends Equatable {
  final String productId;
  final String itemName;
  final String shopName;
  final String imageUrl;
  final double price;
  final int quantity;

  const OrderItemEntity({
    required this.productId,
    required this.itemName,
    required this.shopName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
        productId,
        itemName,
        shopName,
        imageUrl,
        price,
        quantity,
      ];
} 