import 'package:compareitr/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:compareitr/core/common/network/network_connection.dart';
import 'package:compareitr/features/auth/data/datasourses/auth_remote_data_source.dart';
import 'package:compareitr/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:compareitr/features/auth/domain/repository/auth_repository.dart';
import 'package:compareitr/features/auth/domain/usecases/current_user.dart';
import 'package:compareitr/features/auth/domain/usecases/update_user.dart';
import 'package:compareitr/features/auth/domain/usecases/user_login.dart';
import 'package:compareitr/features/auth/domain/usecases/user_sign_up.dart';
import 'package:compareitr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:compareitr/features/card_swiper/data/datasources/card_swiper_remote_data_source.dart';
import 'package:compareitr/features/card_swiper/data/repository/card_swiper_repository_impl.dart';
import 'package:compareitr/features/card_swiper/domain/repository/card_swiper_repository.dart';
import 'package:compareitr/features/cart/domain/repository/cart_repository.dart';
import 'package:compareitr/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:compareitr/features/order/data/datasources/order_remote_data_source.dart';
import 'package:compareitr/features/order/data/repository/order_repository_impl.dart';
import 'package:compareitr/features/order/domain/repositories/order_repository.dart';
import 'package:compareitr/features/order/domain/usecases/create_order.dart';
import 'package:compareitr/features/order/domain/usecases/get_order_by_id.dart';
import 'package:compareitr/features/order/domain/usecases/get_user_order.dart';
import 'package:compareitr/features/order/presentation/bloc/order_bloc.dart';
import 'package:compareitr/features/recently_viewed/data/datasource/recently_viewed_local_datasource.dart';
import 'package:compareitr/features/recently_viewed/data/datasource/recently_viewed_remote_data_source.dart';
import 'package:compareitr/features/recently_viewed/data/repository/recent_repo_impl.dart';
import 'package:compareitr/features/recently_viewed/domain/repository/recent_repo.dart';
import 'package:compareitr/features/recently_viewed/domain/usecases/add_recent_item_usecase.dart';
import 'package:compareitr/features/recently_viewed/domain/usecases/get_recent_items_usecase.dart';
import 'package:compareitr/features/recently_viewed/domain/usecases/remove_recent_item_usecase.dart';
import 'package:compareitr/features/recently_viewed/presentation/bloc/recent_bloc.dart';
import 'package:compareitr/features/sales/data/datasources/sale_card_remote_data_source.dart';
import 'package:compareitr/features/sales/data/datasources/sale_products_data_source.dart';
import 'package:compareitr/features/sales/data/repository/sale_card_repository_impl.dart';
import 'package:compareitr/features/sales/data/repository/sale_product_repository_impl.dart';
import 'package:compareitr/features/sales/domain/repository/sale_card_repository.dart';
import 'package:compareitr/features/sales/domain/repository/sale_product_repository.dart';
import 'package:compareitr/features/sales/domain/usecases/get_all_sale_card_usecase.dart';
import 'package:compareitr/features/sales/domain/usecases/get_all_sale_products_usecase.dart';
import 'package:compareitr/features/sales/presentation/bloc/salecard_bloc.dart';
import 'package:compareitr/features/sales/presentation/bloc/saleproducts_bloc.dart';
import 'package:compareitr/features/shops/data/datasources/shops_local_datasource.dart';
import 'package:compareitr/features/shops/domain/usecase/get_categories.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/secrets/app_secrets.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/card_swiper/domain/usecase/card_swiper.dart';
import 'features/card_swiper/presentation/bloc/bloc/card_swiper_bloc.dart';
import 'features/cart/data/datasources/cart_remote_data_source.dart';
import 'features/cart/data/repository/cart_repository_impl.dart';
import 'features/cart/domain/usecases/add_cart_item_usecase.dart';
import 'features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'features/cart/presentation/bloc/cart_bloc_bloc.dart';
import 'features/shops/data/datasources/shops_remote_datasource.dart';
import 'features/shops/data/repository/repo_impl.dart';
import 'features/shops/domain/repository/repo.dart';
import 'features/shops/domain/usecase/get_all_products.dart';
import 'features/shops/domain/usecase/get_all_shops.dart';
import 'features/shops/presentation/bloc/all_categories/all_categories_bloc.dart';
import 'features/shops/presentation/bloc/all_products/all_products_bloc.dart';
import 'features/shops/presentation/bloc/all_shops/all_shops_bloc.dart';
import 'package:compareitr/features/saved/data/datasources/saved_remote_data_source.dart';
import 'package:compareitr/features/saved/data/repository/saved_repository_impl.dart';
import 'package:compareitr/features/saved/domain/repository/saved_repository.dart';
import 'package:compareitr/features/saved/domain/usecases/add_saved_item_usecase.dart';
import 'package:compareitr/features/saved/domain/usecases/get_saved_items_usecase.dart';
import 'package:compareitr/features/saved/domain/usecases/remove_saved_item_usecase.dart';
import 'package:compareitr/features/saved/presentation/bloc/saved_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initdependencies() async {
  _initAuth();
  _initShops();
  _initCardSwiper();
  _initCart();
  _initRecentlyViewed();
  _initSaved();
  _initSalecard();
  _initSaleProduct();
  _initOrder();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseKey,
  );

  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  await Hive.openBox('shops');

  serviceLocator.registerLazySingleton(() => Hive.box('shops'));

  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(serviceLocator()));
}

void _initShops() {
  serviceLocator
    ..registerFactory<ShopsRemoteDataSource>(
      () => ShopsRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<ShopsLocalDataSource>(
      () => ShopsLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<ShopsRepository>(
      () => ShopsRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetAllShopsUsecase>(
      () => GetAllShopsUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetCategoriesUsecase>(
      () => GetCategoriesUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<AllShopsBloc>(
      () => AllShopsBloc(
        getAllShopsUsecase: serviceLocator(),
      ),
    )
    ..registerFactory<GetAllProductsUseCase>(
      () => GetAllProductsUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory<AllProductsBloc>(
      () => AllProductsBloc(
        getAllProductsUseCase: serviceLocator(),
      ),
    )
    ..registerFactory<AllCategoriesBloc>(
      () => AllCategoriesBloc(
        getCategoriesUsecase: serviceLocator(),
      ),
    );
  // Debugging: Check if dependencies are correctly registered
}

void _initCardSwiper() {
  serviceLocator
    ..registerFactory<CardSwiperRemoteDataSource>(
      () => CardSwiperRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<CardSwiperRepository>(
      () => CardSwiperRepositoryImpl(
        remoteDataSource: serviceLocator(),
      ),
    )
    ..registerFactory<GetAllCardSwiperPicturesUseCase>(
      () => GetAllCardSwiperPicturesUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory<CardSwiperBloc>(
      () => CardSwiperBloc(
        getAllCardSwiperPicturesUseCase: serviceLocator(),
      ),
    );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => LogoutUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateUserProfile(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AuthBloc(
          userSignUp: serviceLocator(),
          userLogin: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator(),
          logoutUsecase: serviceLocator(),
          updateUserProfile: serviceLocator()),
    );
}

void _initCart() {
  serviceLocator
    ..registerFactory<CartRemoteDataSource>(
      // Register the data source
      () => CartRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<CartRepository>(
      // Register the repository
      () => CartRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AddCartItemUsecase>(
      // Register the use case for adding an item to the cart
      () => AddCartItemUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<RemoveCartItemUsecase>(
      // Register the use case for removing an item from the cart
      () => RemoveCartItemUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetCartItemsUsecase>(
      // Register the use case for getting all cart items
      () => GetCartItemsUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdateCartItemUsecase>(
      // Register the use case for getting all cart items
      () => UpdateCartItemUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<CartBloc>(
      // Register the CartBloc
      () => CartBloc(
        addCartItemUsecase: serviceLocator(),
        removeCartItemUsecase: serviceLocator(),
        getCartItemsUsecase: serviceLocator(),
        updateCartItemUsecase: serviceLocator(),
      ),
    );
}

void _initRecentlyViewed() {
  serviceLocator
    ..registerFactory<RecentlyViewedRemoteDataSource>(
      () => RecentlyViewedRemoteDataSourceImpl(
        serviceLocator(), // Assuming you have a SupabaseClient registered
      ),
    )
    ..registerFactory<RecentlyViewedLocalDataSource>(
      () => RecentlyViewedLocalDataSourceImpl(
        serviceLocator(), // Assuming you have a SupabaseClient registered
      ),
    )
    ..registerFactory<RecentRepository>(
      () => RecentRepoImpl(
        serviceLocator(),
        
      ),
    )
    ..registerFactory<AddRecentItemUsecase>(
      () => AddRecentItemUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetRecentItemsUsecase>(
      () => GetRecentItemsUsecase(
        serviceLocator(),
      ),
    )

    ..registerFactory<RemoveRecentItemUsecase>(
      () => RemoveRecentItemUsecase(
        serviceLocator(),
      ),
    )

    ..registerFactory<RecentBloc>(
      () => RecentBloc(
        getRecentItemsUsecase: serviceLocator(),
        addRecentItemUsecase: serviceLocator(),
        removeRecentItemUsecase: serviceLocator(),
      ),
    );
}

void _initSaved() {
  serviceLocator
    ..registerFactory<SavedRemoteDataSource>(
      () => SavedRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<SavedRepository>(
      () => SavedRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AddSavedItemUsecase>(
      () => AddSavedItemUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<RemoveSavedItemUsecase>(
      () => RemoveSavedItemUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetSavedItemsUsecase>(
      () => GetSavedItemsUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<SavedBloc>(
      () => SavedBloc(
        addSavedItemUsecase: serviceLocator(),
        removeSavedItemUsecase: serviceLocator(),
        getSavedItemsUsecase: serviceLocator(),
      ),
    );
}

void _initSalecard() {
  serviceLocator
    ..registerFactory<SaleCardRemoteDataSource>(
      () => SaleCardRemoteDataSourceImpl(
        serviceLocator(), // Assuming you use a SupabaseClient
      ),
    )
    ..registerFactory<SaleCardRepository>(
      () => SaleCardRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetSaleCardAllUsecase>(
      () => GetSaleCardAllUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<SalecardBloc>(
      () => SalecardBloc(
        getSaleCardAllUsecase: serviceLocator(),
      ),
    );
}

void _initSaleProduct() {
  serviceLocator
    ..registerFactory<SaleProductRemoteDataSource>(
      () => SaleProductRemoteDataSourceImpl(
        serviceLocator(), // Assuming you use a SupabaseClient
      ),
    )
    ..registerFactory<SaleProductRepository>(
      () => SaleProductRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetAllSaleProductsUsecase>(
      () => GetAllSaleProductsUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<SaleProductBloc>(
      () => SaleProductBloc(
        getAllProductsUseCase: serviceLocator(),
      ),
    );
}

void _initOrder() {
  serviceLocator
    ..registerFactory<OrderRemoteDataSource>( 
      () => OrderRemoteDataSourceImpl(
        serviceLocator(), // Assuming you have a SupabaseClient registered
      ),
    )
    ..registerFactory<OrderRepository>(
      () => OrderRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<CreateOrder>(
      () => CreateOrder(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetUserOrders>(
      () => GetUserOrders(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetOrderById>(
      () => GetOrderById(
        serviceLocator(),
      ),
    )
    ..registerFactory<OrderBloc>(
      () => OrderBloc(
        createOrderUsecase: serviceLocator(),
        getUserOrdersUsecase: serviceLocator(),
        getOrderByIdUsecase: serviceLocator(),
      ),
    );
}
// ... existing code ...
