part of 'cart_bloc_bloc.dart';

@immutable
sealed class CartEvent {}

final class AddCartItem extends CartEvent {
  final String cartId;
  final String itemName;
  final String shopName;
  final String imageUrl;
  final double price;
  final int quantity;

  AddCartItem({
    required this.cartId,
    required this.itemName,
    required this.shopName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });
}

final class RemoveCartItem extends CartEvent {
  final String cartId;
  final String productId;

  RemoveCartItem({required this.cartId,required this.productId});
}

final class GetCartItems extends CartEvent {
  final String cartId;

  GetCartItems({required this.cartId,
  });
}

final class UpdateCartItem extends CartEvent {
  final String cartId;
  final String productId;
  final int quantity;

  UpdateCartItem({
    required this.cartId,
    required this.productId,
    required this.quantity,
  });
}
