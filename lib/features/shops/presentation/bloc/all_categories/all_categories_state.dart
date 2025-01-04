part of 'all_categories_bloc.dart';

@immutable
sealed class AllCategoriesState {}

final class AllCategoriesInitial extends AllCategoriesState {}

final class AllCategoriesLoading extends AllCategoriesState {}

final class AllCategoriesSuccess extends AllCategoriesState {
  final List<CategoryEntity> categories;

  AllCategoriesSuccess({required this.categories});
}

final class AllCategoriesFailure extends AllCategoriesState {
  final String message;

  AllCategoriesFailure({required this.message});
}

// state for categories by shop name
final class CategoriesByShopNameSuccess extends AllCategoriesState {
  final List<CategoryEntity> categories;

  CategoriesByShopNameSuccess({required this.categories});
}
