import 'package:compareitr/core/common/entities/cart_entity.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class CartRepository {
  Future<Either<Failure, CartEntity>> addCartItem({
    required String cartId,
    required String itemName,
    required String shopName,
    required String imageUrl,
    required double price,
    required int quantity,
  });
  Future<Either<Failure, void>> removeCartItem(String id);
  Future<Either<Failure, List<CartEntity>>> getCartItems(String cartId);
  Future<Either<Failure, void>> updateCartItem({
    required String cartId,
    required String id,
    required int quantity,
  });
}
