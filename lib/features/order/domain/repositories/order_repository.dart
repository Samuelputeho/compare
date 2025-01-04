import 'package:fpdart/fpdart.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/features/order/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder({
    required String userId,
    required List<OrderItemEntity> items,
    required double subtotal,
    required double deliveryFee,
    required double totalAmount,
    required String deliveryAddress,
  });

  Future<Either<Failure, List<OrderEntity>>> getUserOrders(String userId);
  
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);
} 