part of 'saleproducts_bloc.dart';

@immutable
sealed class SaleproductsEvent {}

final class GetAllSaleProductsEvent extends SaleproductsEvent {}
