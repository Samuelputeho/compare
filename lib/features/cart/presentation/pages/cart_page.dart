import 'package:compareitr/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:compareitr/features/cart/presentation/widgets/cart_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:compareitr/features/cart/presentation/bloc/cart_bloc_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();

    // Log the current user state
    final appUserState = context.read<AppUserCubit>().state;
    print("AppUserCubit State: $appUserState"); // Log the state

    if (appUserState is AppUserLoggedIn) {
      final cartId = appUserState.user.id; // Fetch the cartId from the logged-in user
      print("CartId: $cartId"); // Log the cartId

      // Dispatch GetCartItems event only if cartId is not empty
      if (cartId.isNotEmpty) {
        print("Dispatching GetCartItems event...");
        context.read<CartBloc>().add(GetCartItems(cartId: cartId));
      } else {
        print("CartId is empty, skipping GetCartItems event.");
      }
    } else {
      print("User is not logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              iconSize: 20,
            ),
          ),
        ),
        title: const Text('Cart'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_horiz_outlined),
                iconSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          } else if (state is CartLoaded) {
            final cartItems = state.cartItems;

            // Calculate total price
            double totalPrice = cartItems.fold(
                0, (sum, item) => sum + (item.price * item.quantity));

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: cartItems.length,
                      separatorBuilder: (context, index) => SizedBox(height: 7),
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        return CartTile(
                          cartItem: cartItem,
                          onRemove: () {
                            final cartId = cartItem.cartId;
                            final productId = cartItem.id; // Use productId

                            if (cartId.isNotEmpty) {
                              context.read<CartBloc>().add(
                                RemoveCartItem(
                                  cartId: cartId,
                                  productId: productId, // Pass productId here
                                ),
                              );
                            }
                          },
                          onIncrease: () {
                            final cartId = cartItem.cartId;
                            final productId = cartItem.id; // Use productId

                            if (cartId.isNotEmpty) {
                              context.read<CartBloc>().add(
                                RemoveCartItem(
                                  cartId: cartId,
                                  productId: productId, // Pass productId here
                                ),
                              );
                              context.read<CartBloc>().add(
                                AddCartItem(
                                  cartId: cartItem.cartId,
                                  itemName: cartItem.itemName,
                                  shopName: cartItem.shopName,
                                  imageUrl: cartItem.imageUrl,
                                  price: cartItem.price,
                                  quantity: cartItem.quantity + 1,
                                ),
                              );
                            }
                          },
                          onDecrease: () {
                            final cartId = cartItem.cartId;
                            final productId = cartItem.id; // Use productId

                            if (cartId.isNotEmpty) {
                              context.read<CartBloc>().add(
                                RemoveCartItem(
                                  cartId: cartId,
                                  productId: productId, // Pass productId here
                                ),
                              );
                              if (cartItem.quantity > 1) {
                                context.read<CartBloc>().add(
                                  AddCartItem(
                                    cartId: cartItem.cartId,
                                    itemName: cartItem.itemName,
                                    shopName: cartItem.shopName,
                                    imageUrl: cartItem.imageUrl,
                                    price: cartItem.price,
                                    quantity: cartItem.quantity - 1,
                                  ),
                                );
                              } else {
                                context.read<CartBloc>().add(
                                  RemoveCartItem(
                                    cartId: cartItem.cartId,
                                    productId: productId, // Pass productId here
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'N\$ ${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('No items in cart.'));
        },
      ),
    );
  }
}
