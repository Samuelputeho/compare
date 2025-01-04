import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/core/common/entities/cart_entity.dart';
import 'package:compareitr/features/cart/domain/repository/cart_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCartItemsUsecase implements UseCase<List<CartEntity>, String> {
  final CartRepository cartRepository;

  const GetCartItemsUsecase(this.cartRepository);

  @override
  Future<Either<Failure, List<CartEntity>>> call(String cartId) async {
    return await cartRepository.getCartItems(cartId);
  }
}
