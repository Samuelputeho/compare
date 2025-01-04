import 'package:fpdart/fpdart.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/order/domain/entities/order_entity.dart';
import 'package:compareitr/features/order/domain/repositories/order_repository.dart';

class GetUserOrders implements UseCase<List<OrderEntity>, String> {
  final OrderRepository repository;

  GetUserOrders(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(String userId) async {
    return await repository.getUserOrders(userId);
  }
}
