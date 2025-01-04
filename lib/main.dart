import 'package:compareitr/bottom_bar.dart';
import 'package:compareitr/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:compareitr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:compareitr/features/card_swiper/presentation/bloc/bloc/card_swiper_bloc.dart';
import 'package:compareitr/features/order/presentation/bloc/order_bloc.dart';
import 'package:compareitr/features/recently_viewed/presentation/bloc/recent_bloc.dart';
import 'package:compareitr/features/sales/presentation/bloc/salecard_bloc.dart';
import 'package:compareitr/features/sales/presentation/bloc/saleproducts_bloc.dart';
import 'package:compareitr/features/saved/presentation/bloc/saved_bloc.dart';
import 'package:compareitr/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/cart/presentation/bloc/cart_bloc_bloc.dart';
import 'features/shops/presentation/bloc/all_categories/all_categories_bloc.dart';
import 'features/shops/presentation/bloc/all_products/all_products_bloc.dart';
import 'features/shops/presentation/bloc/all_shops/all_shops_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initdependencies();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AllCategoriesBloc>(),
      ),
      BlocProvider(
        create: (_) {
          return serviceLocator<AllShopsBloc>();
        },
      ),
      BlocProvider(
        create: (_) {
          return serviceLocator<AllProductsBloc>();
        },
      ),
      BlocProvider(
        create: (_) => serviceLocator<CardSwiperBloc>(),
      ),
      BlocProvider(
        // Added CartBloc provider
        create: (_) => serviceLocator<CartBloc>(),
      ),
      BlocProvider(
        // Added CartBloc provider
        create: (_) => serviceLocator<RecentBloc>(),
      ),
      BlocProvider(
        // Added CartBloc provider
        create: (_) => serviceLocator<SavedBloc>(),
      ),
      BlocProvider(
        // Added CartBloc provider
        create: (_) => serviceLocator<SalecardBloc>(),
      ),
      BlocProvider(
        // Added CartBloc provider
        create: (_) => serviceLocator<SaleProductBloc>(),
      ),
      BlocProvider(
        // Added CartBloc provider
        create: (_) => serviceLocator<OrderBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CompareItg',
      theme: AppTheme.lightThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            // Wait for the user to be logged in before dispatching cart actions
            final cartId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

            // Only dispatch GetCartItems if cartId is available and valid
            if (cartId.isNotEmpty) {
              context.read<CartBloc>().add(GetCartItems(cartId: cartId));
            }
context.read<AuthBloc>();
            // Dispatch other events
            context.read<AllCategoriesBloc>().add(GetAllCategoriesEvent());
            context.read<AllShopsBloc>().add(GetAllShopsEvent());
            context.read<AllProductsBloc>().add(GetAllProductsEvent());
            context.read<CardSwiperBloc>().add(GetAllCardSwiperPicturesEvent());
            context.read<RecentBloc>().add(GetRecentItems(recentId: cartId));
            context.read<SavedBloc>().add(GetSavedItems(savedId: cartId));
            context.read<SalecardBloc>().add(GetAllSaleCardEvent());
            context.read<SaleProductBloc>().add(GetAllSaleProductsEvent());
            context.read<OrderBloc>().add( GetOrderByIdEvent(orderId: cartId));

            return const MainNavigationPage();
          }
          // When the user is not logged in, navigate to Login page
          context.read<AllCategoriesBloc>().add(GetAllCategoriesEvent());
          context.read<AuthBloc>();
          return const LoginPage();
        },
      ),
    );
  }
}