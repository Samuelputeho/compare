import 'package:compareitr/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:compareitr/features/cart/presentation/bloc/cart_bloc_bloc.dart';
import 'package:compareitr/features/recently_viewed/presentation/bloc/recent_bloc.dart';
import 'package:compareitr/features/saved/presentation/bloc/saved_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../bloc/all_categories/all_categories_bloc.dart';
import '../bloc/all_shops/all_shops_bloc.dart';
import '../widgets/nov_tile.dart';
import '../widgets/shop_tile.dart';
import 'categories_page.dart';
import 'package:compareitr/features/card_swiper/presentation/bloc/bloc/card_swiper_bloc.dart';


// Ensure this model is defined
// Adjust the import based on your project structure

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    final recentId = (context.read<AppUserCubit>().state as AppUserLoggedIn)
        .user
        .id; 
        final cartId = (context.read<AppUserCubit>().state as AppUserLoggedIn)
        .user
        .id; 
        context.read<CartBloc>().add(GetCartItems(cartId: cartId));// Get user ID
    context.read<RecentBloc>().add(GetRecentItems(recentId: recentId));
    context.read<AllShopsBloc>().add(GetAllShopsEvent());
    final savedId = (context.read<AppUserCubit>().state as AppUserLoggedIn)
        .user
        .id; // Get user ID
    context
        .read<SavedBloc>()
        .add(GetSavedItems(savedId: savedId));

    context.read<AllCategoriesBloc>().add(GetAllCategoriesEvent());
    context
        .read<CardSwiperBloc>()
        .add(GetAllCardSwiperPicturesEvent()); // Fetch card swiper pictures
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % 3; // Assuming you have 3 pages
      });

      if (_currentIndex < 3) {
        // Ensure this matches the number of pages
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _showRemoveDialog(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Item'),
          content: Text('Are you sure you want to remove this item from recently viewed?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final recentId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
                context.read<RecentBloc>().add(RemoveRecentlyItem(recentId: recentId, id: itemId)); // Dispatch the remove event
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double imageHeight = 150.0;
    const double dotSize = 12.0;
    const double dotSpacing = 8.0;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sales container
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: double.infinity,
                  height: imageHeight,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 219, 217, 217),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: BlocBuilder<CardSwiperBloc, CardSwiperState>(
                    builder: (context, state) {
                      if (state is CardSwiperLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is CardSwiperFailure) {
                        return Center(child: Text(state.message));
                      } else if (state is CardSwiperSuccess) {
                        return PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemCount: state.pictures.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                state.pictures[index]
                                    .image, // Fetching from the database
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                        );
                      }
                      return Center(child: Text('No images available'));
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: BlocBuilder<CardSwiperBloc, CardSwiperState>(
                    builder: (context, state) {
                      if (state is CardSwiperSuccess) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(state.pictures.length, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: dotSpacing / 2),
                              width: _currentIndex == index
                                  ? dotSize
                                  : dotSize - 4,
                              height: _currentIndex == index
                                  ? dotSize
                                  : dotSize - 4,
                              decoration: BoxDecoration(
                                color: _currentIndex == index
                                    ? Colors.green
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        );
                      }
                      return const SizedBox(); // Handle other states if necessary
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Recently Viewed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            BlocBuilder<RecentBloc, RecentState>(
              builder: (context, state) {
                if (state is RecentLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RecentError) {
                  return Center(child: Text(state.message));
                } else if (state is RecentLoaded) {
                  final recentItems = state.recentItems.reversed.toList();
                  if (recentItems.isEmpty) {
                    return const Center(
                        child: Text('No recently viewed items'));
                  }
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.width * 0.7,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recentItems.length,
                      itemBuilder: (context, index) {
                        final item = recentItems[index];
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

                            return BlocBuilder<SavedBloc, SavedState>(
                              builder: (context, savedState) {
                                bool isSaved = false;
                                if (savedState is SavedLoaded) {
                                  isSaved = savedState.savedItems.any((savedItem) =>
                                    savedItem.name == item.name &&
                                    savedItem.shopName == item.shopName &&
                                    savedItem.price == item.price
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: NovTile(
                                    foodImage: item.image,
                                    foodName: item.name,
                                    foodPrice: 'N\$${item.price.toStringAsFixed(2)}',
                                    foodQuantity: item.measure,
                                    foodRating: '5.0',
                                    foodShop: item.shopName,
                                    isInCart: isInCart,
                                    isSaved: isSaved,
                                    onHeartTap: () async {
                                      try {
                                        // Fetch saved items from the bloc
                                        final savedItemsState =
                                            context.read<SavedBloc>().state;

                                        // Check if the state is loaded
                                        if (savedItemsState is SavedLoaded) {
                                          // Check if the item already exists in the saved items
                                          final exists = savedItemsState.savedItems
                                              .any((savedItem) {
                                            return savedItem.name == item.name &&
                                                savedItem.price == item.price;
                                          });

                                          if (exists) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                  content:
                                                      Text('Product is already added')),
                                            );
                                          } else {
                                            final savedId = (context
                                                    .read<AppUserCubit>()
                                                    .state as AppUserLoggedIn)
                                                .user
                                                .id;
                                            // Dispatch the AddSavedItem event to the bloc
                                            context.read<SavedBloc>().add(AddSavedItem(
                                                  name: item.name,
                                                  image: item.image,
                                                  measure: item.measure,
                                                  shopName: item.shopName,
                                                  savedId:
                                                      savedId, // Use your specific savedId here
                                                  price: item.price,
                                                ));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Product added to saved items')),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Failed to fetch saved items')),
                                          );
                                        }
                                      } catch (e) {
                                        // Log the error
                                        print(
                                            'Error occurred while adding item to saved: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text('An error occurred: $e')),
                                        );
                                      }
                                    },
                                    onPlusTap: () async {
                                      try {
                                        // Get cart state
                                        final cartState = context.read<CartBloc>().state;
                                        
                                        if (cartState is CartLoaded) {
                                          // Check if item already exists in cart
                                          final exists = cartState.cartItems.any((cartItem) =>
                                            cartItem.itemName == item.name &&
                                            cartItem.shopName == item.shopName &&
                                            cartItem.price == item.price
                                          );

                                          if (exists) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Product is already in cart')),
                                            );
                                          } else {
                                            // Get user ID for cart
                                            final cartId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
                                            
                                            // Add item to cart
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
                                          }
                                        }
                                      } catch (e) {
                                        print('Error adding item to cart: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('An error occurred: $e')),
                                        );
                                      }
                                    },
                                    onRemoveTap: () {
                                      print('Removing item with ID: ${item.id}');
                                      _showRemoveDialog(context, item.id);
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const Center(child: Text('No recently viewed items'));
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'Grocery Stores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            BlocConsumer<AllShopsBloc, AllShopsState>(
              listener: (context, state) {
                if (state is AllShopsFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is AllShopsLoading) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.width * 0.93,
                    ),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      shrinkWrap: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.loadingShops.length,
                      itemBuilder: (context, index) {
                        final shop = state.loadingShops[index];
                        return ShopTile(
                          onTap: () {},
                          shopName: shop.shopName,
                          shopLogo: shop.shopLogoUrl,
                        );
                      },
                    ),
                  );
                }

                if (state is AllShopsSuccess) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.width * 0.93,
                    ),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      shrinkWrap: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.shops.length,
                      itemBuilder: (context, index) {
                        final shop = state.shops[index];
                        return ShopTile(
                          onTap: () {
                            context.read<AllCategoriesBloc>().add(
                                  GetCategoriesByShopNameEvent(
                                      shopName: shop.shopName),
                                );
                            // navigate to categories page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoriesPage(
                                  storeName: shop.shopName,
                                ),
                              ),
                            );
                          },
                          shopName: shop.shopName,
                          shopLogo: shop.shopLogoUrl,
                        );
                      },
                    ),
                  );
                }

                return const Center(
                  child: Text('No shops available'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}