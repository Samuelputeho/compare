import 'package:compareitr/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:compareitr/features/likes/presentation/widgets/saved_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:compareitr/features/saved/presentation/bloc/saved_bloc.dart';
import 'package:compareitr/features/cart/presentation/bloc/cart_bloc_bloc.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  @override
  void initState() {
    super.initState();
    final userId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context.read<SavedBloc>().add(GetSavedItems(savedId: userId));
    context.read<CartBloc>().add(GetCartItems(cartId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Items"),
      ),
      body: BlocBuilder<SavedBloc, SavedState>(
        builder: (context, state) {
          if (state is SavedLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SavedError) {
            return Center(child: Text(state.message));
          } else if (state is SavedLoaded) {
            if (state.savedItems.isEmpty) {
              return const Center(child: Text('No saved items'));
            }
            final reversedItems = state.savedItems.reversed.toList();
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: reversedItems.length,
              itemBuilder: (context, index) {
                final item = reversedItems[index];
                return BlocBuilder<CartBloc, CartState>(
                  builder: (context, cartState) {
                    bool isInCart = false;
                    if (cartState is CartLoaded) {
                      isInCart = cartState.cartItems.any((cartItem) => 
                        cartItem.itemName == item.name &&
                        cartItem.shopName == item.shopName &&
                        cartItem.price == item.price
                      );
                    }

                    return SavedTile(
                      foodImage: item.image,
                      foodName: item.name,
                      foodPrice: 'N\$${item.price.toStringAsFixed(2)}',
                      foodQuantity: item.measure,
                      foodShop: item.shopName,
                      isInCart: isInCart,
                      onDelete: () {
                        final savedId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
                        context.read<SavedBloc>().add(RemoveSavedItem(id: item.id, savedId: savedId));
                      },
                      onPlusTap: () async {
                        try {
                          if (!isInCart) {
                            final cartId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
                            
                            context.read<CartBloc>().add(AddCartItem(
                              cartId: cartId,
                              itemName: item.name,
                              shopName: item.shopName,
                              imageUrl: item.image,
                              price: item.price,
                              quantity: 1,
                            ));

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Product added to cart')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Product is already in cart')),
                            );
                          }
                        } catch (e) {
                          print('Error adding item to cart: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error occurred: $e')),
                          );
                        }
                      },
                    );
                  },
                );
              },
            );
          }
          return const Center(child: Text('No saved items'));
        },
      ),
    );
  }
}
