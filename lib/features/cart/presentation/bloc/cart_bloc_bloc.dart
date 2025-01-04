import 'package:compareitr/core/common/entities/cart_entity.dart';
import 'package:compareitr/features/cart/domain/usecases/add_cart_item_usecase.dart';
import 'package:compareitr/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:compareitr/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:compareitr/features/cart/domain/usecases/update_cart_item_usecase.dart'; // Add the new use case
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_bloc_event.dart';
part 'cart_bloc_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddCartItemUsecase _addCartItemUsecase;
  final RemoveCartItemUsecase _removeCartItemUsecase;
  final GetCartItemsUsecase _getCartItemsUsecase;
  final UpdateCartItemUsecase _updateCartItemUsecase; // Add the new use case

  CartBloc({
    required AddCartItemUsecase addCartItemUsecase,
    required RemoveCartItemUsecase removeCartItemUsecase,
    required GetCartItemsUsecase getCartItemsUsecase,
    required UpdateCartItemUsecase updateCartItemUsecase, // Inject the new use case
  })  : _addCartItemUsecase = addCartItemUsecase,
        _removeCartItemUsecase = removeCartItemUsecase,
        _getCartItemsUsecase = getCartItemsUsecase,
        _updateCartItemUsecase = updateCartItemUsecase, // Initialize the new use case
        super(CartInitial()) {
    on<AddCartItem>(_onAddCartItem);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<GetCartItems>(_onGetCartItems);
    on<UpdateCartItem>(_onUpdateCartItem); // Add the new event handler
  }

  Future<void> _onAddCartItem(
    AddCartItem event, Emitter<CartState> emit) async {
  emit(CartLoading()); // Show loading before adding
  final result = await _addCartItemUsecase(AddCartItemParams(
    cartId: event.cartId,
    itemName: event.itemName,
    shopName: event.shopName,
    imageUrl: event.imageUrl,
    price: event.price,
    quantity: event.quantity,
  ));

    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (_) {
        add(GetCartItems(cartId: event.cartId));
      },
    );
  }

  Future<void> _onRemoveCartItem(RemoveCartItem event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await _removeCartItemUsecase(RemoveCartItemParams(
      productId: event.productId,
    ));

    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (_) {
        add(GetCartItems(cartId: event.cartId));
      },
    );
  }

  Future<void> _onGetCartItems(GetCartItems event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await _getCartItemsUsecase(event.cartId);

    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (cartItems) => emit(CartLoaded(cartItems: cartItems)),
    );
  }

  Future<void> _onUpdateCartItem(UpdateCartItem event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await _updateCartItemUsecase(UpdateCartItemParams(
      cartId: event.cartId,
      id: event.id,
      quantity: event.quantity,
    ));

    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (_) {
        // Fetch the updated cart items immediately after the update
        add(GetCartItems(cartId: event.cartId));
      },
    );
  }
}
