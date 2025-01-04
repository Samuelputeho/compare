import 'package:fpdart/fpdart.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/order/domain/entities/order_entity.dart';
import 'package:compareitr/features/order/domain/repositories/order_repository.dart';

class GetOrderById implements UseCase<OrderEntity, String> {
  final OrderRepository repository;

  GetOrderById(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(String orderId) async {
    return await repository.getOrderById(orderId);
  }
}
