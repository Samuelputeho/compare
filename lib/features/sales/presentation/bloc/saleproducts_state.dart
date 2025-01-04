part of 'saleproducts_bloc.dart';

@immutable
sealed class SaleproductsState {}

final class SaleproductsInitial extends SaleproductsState {}

final class SaleproductsLoading extends SaleproductsState {}

final class SaleproductsSuccess extends SaleproductsState {
  final List<SaleProductsEntity> saleProducts;

  SaleproductsSuccess({required this.saleProducts});
}

final class SaleproductsFailure extends SaleproductsState {
  final String message;

  SaleproductsFailure({required this.message});
}
