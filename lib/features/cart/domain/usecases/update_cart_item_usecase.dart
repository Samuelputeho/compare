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
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}

class UpdateCartItemParams {
  final String cartId;
  final String productId;
  final int quantity;

  UpdateCartItemParams({
    required this.cartId,
    required this.productId,
    required this.quantity,
  });
}
