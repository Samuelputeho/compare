part of 'all_products_bloc.dart';

@immutable
sealed class AllProductsEvent {}

final class GetAllProductsEvent extends AllProductsEvent {}

final class GetProductsByCategoryEvent extends AllProductsEvent {
  final String shopName;
  final String category;

  GetProductsByCategoryEvent({
    required this.shopName,
    required this.category,
  });
}

final class GetProductsBySubCategoryEvent extends AllProductsEvent {
  final String shopName;
  final String category;
  final String subCategory;

  GetProductsBySubCategoryEvent({
    required this.shopName,
    required this.category,
    required this.subCategory,
  });
}

class SearchProductsEvent extends AllProductsEvent {
  final String query;
  SearchProductsEvent(this.query);
}
