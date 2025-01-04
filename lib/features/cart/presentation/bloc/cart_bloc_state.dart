part of 'cart_bloc_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<CartEntity> cartItems;

  CartLoaded({required this.cartItems});
}

final class CartError extends CartState {
  final String message;

  CartError({required this.message});
}
