import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/shops/domain/usecase/get_all_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/entities/product_entity.dart';

part 'all_products_event.dart';
part 'all_products_state.dart';

class AllProductsBloc extends Bloc<AllProductsEvent, AllProductsState> {
  final GetAllProductsUseCase _getAllProductsUseCase;
  static List<ProductEntity> allProducts = [];
  static List<ProductEntity> productsByCategory = [];
  static List<ProductEntity> productsBySubCategory = [];
  static List<String> subCategories = [];

  AllProductsBloc({required GetAllProductsUseCase getAllProductsUseCase})
      : _getAllProductsUseCase = getAllProductsUseCase,
        super(AllProductsInitial()) {
    print(
        "AllProductsBloc created with GetAllProductsUseCase: $getAllProductsUseCase");
    on<AllProductsEvent>((event, emit) {});
    on<GetAllProductsEvent>(_onGetAllProducts);
    on<GetProductsByCategoryEvent>(_onGetProductsByCategory);
    on<GetProductsBySubCategoryEvent>(_onGetProductsBySubCategory);
    on<SearchProductsEvent>(_onSearchProducts);
  }

  Future<void> _onGetAllProducts(
      GetAllProductsEvent event, Emitter<AllProductsState> emit) async {
    final result = await _getAllProductsUseCase.call(NoParams());
    result.fold(
      (l) => emit(GetAllProductsFailure(message: l.message)),
      (r) {
        allProducts = r;
        emit(GetAllProductsSuccess(products: r));
      },
    );
  }

  Future<void> _onGetProductsByCategory(
      GetProductsByCategoryEvent event, Emitter<AllProductsState> emit) async {
    productsByCategory = allProducts
        .where((product) =>
            product.shopName == event.shopName &&
            product.category == event.category)
        .toList();

    subCategories = productsByCategory
        .map((product) => product.subCategory)
        .toSet()
        .toList();

    // same success state
    emit(GetProductsByCategorySuccess(
      products: productsByCategory,
      subCategories: subCategories,
    ));
  }

  Future<void> _onGetProductsBySubCategory(GetProductsBySubCategoryEvent event,
      Emitter<AllProductsState> emit) async {
    productsBySubCategory = allProducts
        .where((product) =>
            product.shopName == event.shopName &&
            product.category == event.category &&
            product.subCategory == event.subCategory)
        .toList();
    // same success state
    emit(
      GetProductsBySubCategorySuccess(products: productsBySubCategory),
    );
  }

  // Update the Bloc with a handler for the SearchProductsEvent
  void _onSearchProducts(
      SearchProductsEvent event, Emitter<AllProductsState> emit) {
    final query = event.query.toLowerCase();

    final searchResults = allProducts
        .where((product) => product.name.toLowerCase().contains(query))
        .toList();

    emit(GetAllProductsSuccess(products: searchResults));
  }
}
