part of 'all_products_bloc.dart';

@immutable
sealed class AllProductsState {}

final class AllProductsInitial extends AllProductsState {}

final class GetAllProductsLoading extends AllProductsState {}

final class GetAllProductsSuccess extends AllProductsState {
  final List<ProductEntity> products;

  GetAllProductsSuccess({required this.products});
}

final class GetAllProductsFailure extends AllProductsState {
  final String message;

  GetAllProductsFailure({required this.message});
}

final class GetProductsByCategoryLoading extends AllProductsState {}

final class GetProductsByCategorySuccess extends AllProductsState {
  final List<ProductEntity> products;
  final List<String> subCategories;

  GetProductsByCategorySuccess({
    required this.products,
    this.subCategories = const [],
  });
}

final class GetProductsByCategoryFailure extends AllProductsState {
  final String message;

  GetProductsByCategoryFailure({required this.message});
}

final class GetProductsBySubCategoryLoading extends AllProductsState {}

final class GetProductsBySubCategorySuccess extends AllProductsState {
  final List<ProductEntity> products;

  GetProductsBySubCategorySuccess({required this.products});
}

final class GetProductsBySubCategoryFailure extends AllProductsState {
  final String message;

  GetProductsBySubCategoryFailure({required this.message});
}
