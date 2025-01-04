import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/cart/domain/repository/cart_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateCartItemUsecase implements UseCase<void, UpdateCartItemParams> {
  final CartRepository cartRepository;

  const UpdateCartItemUsecase(this.cartRepository);

  @override
  Future<Either<Failure, void>> call(UpdateCartItemParams params) async {
    return await cartRepository.updateCartItem(
      cartId: params.cartId,
      id: params.id,
      quantity: params.quantity,
    );
  }
}

class UpdateCartItemParams {
  final String cartId;
  final String id;
  final int quantity;

  UpdateCartItemParams({
    required this.cartId,
    required this.id,
    required this.quantity,
  });
}
