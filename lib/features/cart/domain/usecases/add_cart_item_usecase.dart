import 'package:compareitr/core/common/entities/cart_entity.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/cart/domain/repository/cart_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddCartItemUsecase implements UseCase<CartEntity, AddCartItemParams> {
  final CartRepository cartRepository;

  const AddCartItemUsecase(this.cartRepository);

  @override
  Future<Either<Failure, CartEntity>> call(AddCartItemParams params) async {
    return await cartRepository.addCartItem(
      cartId: params.cartId,
      itemName: params.itemName,
      shopName: params.shopName,
      imageUrl: params.imageUrl,
      price: params.price,
      quantity: params.quantity,
    );
  }
}

class AddCartItemParams {
  final String cartId;
  final String itemName;
  final String shopName;
  final String imageUrl;
  final double price;
  final int quantity;

  AddCartItemParams({
    required this.cartId,
    required this.itemName,
    required this.shopName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });
}
