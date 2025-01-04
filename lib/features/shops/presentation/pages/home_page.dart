import 'dart:async';
import 'package:compareitr/core/common/widgets/text_widget.dart';
import 'package:compareitr/core/theme/app_pallete.dart';
import 'package:compareitr/features/cart/presentation/pages/cart_page.dart';
import 'package:compareitr/features/sales/presentation/pages/sales_page.dart';
import 'package:compareitr/features/shops/presentation/pages/search_page.dart';
import 'package:compareitr/features/shops/presentation/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:compareitr/features/auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < 2) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      if (_pageController.hasClients) {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppPallete.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppPallete.backgroundColor,
          elevation: 0,
          title: Row(
            children: [
              const Icon(IconlyBold.location),
              const SizedBox(width: 5),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return TextWidget(
                      text: 'Loading location...',
                      textSize: 15,
                      color: AppPallete.black,
                    );
                  } else if (state is AuthFailure) {
                    return TextWidget(
                      text: 'Error loading location',
                      textSize: 15,
                      color: AppPallete.black,
                    );
                  } else if (state is AuthSuccess) {
                    final user = state.user;
                    final location = user.location ??
                        'Khomasdal'; // Fallback if not available
                    final street = user.street ??
                        'Plaatjies Street'; // Fallback if not available

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: "Delivery:",
                          textSize: 14,
                          color: AppPallete.primaryColor,
                        ),
                        TextWidget(
                          text: '$location, $street',
                          textSize: 15,
                          color: AppPallete.black,
                        ),
                      ],
                    );
                  } else {
                    return TextWidget(
                      text: 'No user data available',
                      textSize: 15,
                      color: AppPallete.black,
                    );
                  }
                },
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(IconlyLight.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(IconlyLight.bag),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // tabbar
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: AppPallete.grey1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  unselectedLabelColor: AppPallete.secondaryColor,
                  labelColor: AppPallete.black,
                  indicatorPadding: const EdgeInsets.all(3),
                  dividerColor: AppPallete.transparentColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppPallete.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tabs: const [
                    Tab(
                      text: 'Shop',
                    ),
                    Tab(
                      text: 'Sales',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Expanded(
                child: TabBarView(
                  children: [
                    ShopPage(),
                    SalesPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
