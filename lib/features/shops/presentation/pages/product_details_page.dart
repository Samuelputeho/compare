import 'package:compareitr/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:compareitr/core/common/entities/cart_entity.dart';
import 'package:compareitr/core/common/entities/product_entity.dart';
import 'package:compareitr/features/cart/presentation/bloc/cart_bloc_bloc.dart';
import 'package:compareitr/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool _isAdded = false;
  int _quantity = 1;
  bool _isZoomed = false;

  String getShopName() {
    return widget.product.shopName;
  }

  // Function to add or update cart item
  void _addOrUpdateCartItem() {
    final appUserState = context.read<AppUserCubit>().state;

    if (appUserState is AppUserLoggedIn) {
      final cartId = appUserState.user.id;

      if (cartId.isNotEmpty) {
        final state = context.read<CartBloc>().state;

        if (state is CartLoaded) {
          final existingItem = state.cartItems.firstWhere(
            (item) =>
                item.itemName == widget.product.name &&
                item.shopName == getShopName(),
            orElse: () => CartEntity(
              id: '', // Default empty id for new cart item
              cartId: cartId, // Use logged-in user ID for cartId
              itemName: '', // Placeholder if no item found
              shopName: '', // Placeholder
              imageUrl: '', // Placeholder
              price: 0.0, // Placeholder
              quantity: 0, // Placeholder
            ),
          );

          if (existingItem.itemName.isNotEmpty) {
            // If the item exists, log the productId being passed
            print("Removing item with productId: ${existingItem.id}");

            // Remove the item using the correct productId
            context.read<CartBloc>().add(RemoveCartItem(
              cartId: existingItem.cartId, 
              productId: existingItem.id, // Pass correct productId here
            ));

            // Log the add action
            print("Adding item with product: ${widget.product.name} and quantity: $_quantity");

            // Add the updated item back with the new quantity
            context.read<CartBloc>().add(AddCartItem(
              cartId: cartId,
              itemName: widget.product.name,
              shopName: getShopName(),
              imageUrl: widget.product.imageUrl,
              price: widget.product.price,
              quantity: _quantity,
            ));
          } else {
            // If the item doesn't exist, log the add action
            print("Adding new item: ${widget.product.name} with quantity: $_quantity");

            // Add the item to the cart
            context.read<CartBloc>().add(AddCartItem(
              cartId: cartId,
              itemName: widget.product.name,
              shopName: getShopName(),
              imageUrl: widget.product.imageUrl,
              price: widget.product.price,
              quantity: _quantity,
            ));
          }

          // Trigger a refresh by fetching updated cart items
          print("Refreshing cart with cartId: $cartId");
          context.read<CartBloc>().add(GetCartItems(cartId: cartId));
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Ensure the cart is loaded at the start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appUserState = context.read<AppUserCubit>().state;
      if (appUserState is AppUserLoggedIn) {
        final cartId = appUserState.user.id;
        if (cartId.isNotEmpty) {
          context.read<CartBloc>().add(GetCartItems(cartId: cartId));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[300],
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoaded) {
            // After the cart is updated, force UI rebuild
            setState(() {});
          }
          if (state is CartError) {
            // Show error message if CartError state occurs
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            Stack(
              children: [
                // Image section with zoom on double tap
                GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      _isZoomed = !_isZoomed;
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isZoomed
                        ? InteractiveViewer(
                            panEnabled: true,
                            boundaryMargin: EdgeInsets.all(10),
                            minScale: 1.0,
                            maxScale: 4.0,
                            child: Image.network(
                              widget.product.imageUrl,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image.network(
                            widget.product.imageUrl,
                            fit: BoxFit.contain,
                            key: ValueKey<int>(1),
                          ),
                  ),
                ),
                if (_isAdded)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Text(
                          _quantity.toString(),
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      widget.product.measure,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "N\$${widget.product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
                          },
                          child: Icon(
                            IconlyLight.bag,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 20),
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            if (state is CartLoaded) {
                              final existingItem = state.cartItems.firstWhere(
                                (item) =>
                                    item.itemName == widget.product.name &&
                                    item.shopName == getShopName(),
                                orElse: () => CartEntity(id: '', cartId: '', itemName: '', shopName: '', imageUrl: '', price: 0.0, quantity: 0),
                              );

                              if (existingItem.itemName.isNotEmpty) {
                                _quantity = existingItem.quantity;
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.green,
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_quantity > 1) {
                                              _quantity--;
                                            }
                                          });
                                          context.read<CartBloc>().add(UpdateCartItem(
                                            cartId: existingItem.cartId,
                                            id: existingItem.id,
                                            quantity: _quantity,
                                          ));

                                          // Trigger a refresh after the update
                                          _refreshCart();
                                        },
                                        icon: Icon(Icons.remove),
                                        color: Colors.white,
                                      ),
                                      Text(
                                        _quantity.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _quantity++;
                                          });
                                          context.read<CartBloc>().add(UpdateCartItem(
                                            cartId: existingItem.cartId,
                                            id: existingItem.id,
                                            quantity: _quantity,
                                          ));

                                          // Trigger a refresh after the update
                                          _refreshCart();
                                        },
                                        icon: Icon(Icons.add),
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isAdded = true;
                                    });
                                    _addOrUpdateCartItem();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.green,
                                    ),
                                    child: Text(
                                      "Add To Cart",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to force the cart state update
  void _refreshCart() {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      final cartId = appUserState.user.id;
      if (cartId.isNotEmpty) {
        context.read<CartBloc>().add(GetCartItems(cartId: cartId));
      }
    }
  }
}
