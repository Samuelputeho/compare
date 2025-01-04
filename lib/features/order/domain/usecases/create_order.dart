import 'package:fpdart/fpdart.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/order/domain/entities/order_entity.dart';
import 'package:compareitr/features/order/domain/repositories/order_repository.dart';

class CreateOrderParams {
  final String userId;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final String deliveryAddress;

  CreateOrderParams({
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.deliveryAddress,
  });
}

class CreateOrder implements UseCase<OrderEntity, CreateOrderParams> {
  final OrderRepository repository;

  CreateOrder(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) async {
    return await repository.createOrder(
      userId: params.userId,
      items: params.items,
      subtotal: params.subtotal,
      deliveryFee: params.deliveryFee,
      totalAmount: params.totalAmount,
      deliveryAddress: params.deliveryAddress,
    );
  }
} 