part of 'order_bloc.dart';




@immutable
sealed class OrderEvent {}

final class CreateOrderEvent extends OrderEvent {
  final String userId;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final String deliveryAddress;

  CreateOrderEvent({
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.deliveryAddress,
  });
}

final class GetUserOrdersEvent extends OrderEvent {
  final String userId;

  GetUserOrdersEvent({required this.userId});
}

final class GetOrderByIdEvent extends OrderEvent {
  final String orderId;

  GetOrderByIdEvent({required this.orderId});
}
