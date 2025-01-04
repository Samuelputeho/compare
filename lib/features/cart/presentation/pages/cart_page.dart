import 'dart:async';

import 'package:compareitr/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:compareitr/features/cart/presentation/widgets/cart_tile.dart';
import 'package:compareitr/features/location/presentation/pages/location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:compareitr/features/cart/presentation/bloc/cart_bloc_bloc.dart';
import 'package:latlong2/latlong.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Animation controller for color changes
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Duration for one blink cycle
    )..repeat(reverse: true); // Repeat the animation back and forth

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
  void dispose() {
    _controller.dispose(); // Clean up the animation controller
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      final cartId = appUserState.user.id;
      if (cartId.isNotEmpty) {
        context.read<CartBloc>().add(GetCartItems(cartId: cartId));
      }
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
                            // Directly update the quantity
                            context.read<CartBloc>().add(
                              UpdateCartItem(
                                cartId: cartItem.cartId,
                                id: cartItem.id,
                                quantity: cartItem.quantity + 1,
                              ),
                            );
                          },
                          onDecrease: () {
                            if (cartItem.quantity > 1) {
                              // Directly update the quantity
                              context.read<CartBloc>().add(
                                UpdateCartItem(
                                  cartId: cartItem.cartId,
                                  id: cartItem.id,
                                  quantity: cartItem.quantity - 1,
                                ),
                              );
                            } else {
                              context.read<CartBloc>().add(RemoveCartItem(
                                cartId: cartItem.cartId,
                                productId: cartItem.id,
                              ));
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
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
                        SizedBox(height: 16.0),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return ElevatedButton(
                              onPressed: () {
                                // Add your button action here
                               Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => LocationSelectionPage(
      totalPrice: totalPrice, 
      townCenter: LatLng(-22.5609, 17.0658),
    ),
  ),
);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorTween(
                                  begin: Colors.green,
                                  end: Colors.black,
                                ).evaluate(_controller), // Transition between blue and red
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.0),
                              ),
                              child: Text(
                                'Buy Through App',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            );
                          },
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