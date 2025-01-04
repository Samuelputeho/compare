part of 'all_categories_bloc.dart';

@immutable
sealed class AllCategoriesEvent {}

class GetAllCategoriesEvent extends AllCategoriesEvent {}

// get categories by shop name
class GetCategoriesByShopNameEvent extends AllCategoriesEvent {
  final String shopName;

  GetCategoriesByShopNameEvent({required this.shopName});
}
