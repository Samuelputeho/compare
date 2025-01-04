import 'package:compareitr/features/order/data/models/order_model.dart';
import 'package:compareitr/features/order/domain/repositories/order_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:compareitr/core/error/exceptions.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/features/order/data/datasources/order_remote_data_source.dart';
import 'package:compareitr/features/order/domain/entities/order_entity.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required String userId,
    required List<OrderItemEntity> items,
    required double subtotal,
    required double deliveryFee,
    required double totalAmount,
    required String deliveryAddress,
  }) async {
    try {
      final orderModel = await remoteDataSource.createOrder(
        userId: userId,
        items: items.cast<OrderItemModel>(),
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        deliveryAddress: deliveryAddress,
        orderStatus: 'pending',
      );

      return right(orderModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders(String userId) async {
    try {
      final orderModels = await remoteDataSource.getOrdersByUserId(userId);

      return right(orderModels);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) async {
    try {
      final orderModel = await remoteDataSource.getOrderById(orderId);

      return right(orderModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error: $e'));
    }
  }
}
