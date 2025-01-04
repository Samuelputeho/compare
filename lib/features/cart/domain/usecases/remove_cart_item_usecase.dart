import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/cart/domain/repository/cart_repository.dart';
import 'package:fpdart/fpdart.dart';

class RemoveCartItemUsecase implements UseCase<void, RemoveCartItemParams> {
  final CartRepository cartRepository;

  const RemoveCartItemUsecase(this.cartRepository);

  @override
  Future<Either<Failure, void>> call(RemoveCartItemParams params) async {
    return await cartRepository.removeCartItem(params.productId);
  }
}

class RemoveCartItemParams {
  final String productId;

  RemoveCartItemParams({required this.productId});
}
