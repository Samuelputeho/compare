import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/entities/category_entity.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecase/get_categories.dart';

part 'all_categories_event.dart';
part 'all_categories_state.dart';

class AllCategoriesBloc extends Bloc<AllCategoriesEvent, AllCategoriesState> {
  final GetCategoriesUsecase _getCategoriesUsecase;

  static List<CategoryEntity> allCategories = [];
  static List<CategoryEntity> categoriesByShopName = [];

  AllCategoriesBloc({required GetCategoriesUsecase getCategoriesUsecase})
      : _getCategoriesUsecase = getCategoriesUsecase,
        super(AllCategoriesInitial()) {
    on<AllCategoriesEvent>((event, emit) {});
    on<GetAllCategoriesEvent>(_onGetAllCategories);
    on<GetCategoriesByShopNameEvent>(_onGetCategoriesByShopName);
  }

  void _onGetAllCategories(
    GetAllCategoriesEvent event,
    Emitter<AllCategoriesState> emit,
  ) async {
    emit(AllCategoriesLoading());
    final res = await _getCategoriesUsecase(NoParams());
    res.fold(
      (l) => emit(AllCategoriesFailure(message: l.message)),
      (r) {
        allCategories = r;
        emit(AllCategoriesSuccess(categories: r));
      },
    );
  }

  void _onGetCategoriesByShopName(
    GetCategoriesByShopNameEvent event,
    Emitter<AllCategoriesState> emit,
  ) async {
    emit(AllCategoriesLoading());
    
    // If allCategories is empty, fetch them first
    if (allCategories.isEmpty) {
      final res = await _getCategoriesUsecase(NoParams());
      res.fold(
        (l) => emit(AllCategoriesFailure(message: l.message)),
        (r) {
          allCategories = r;
        },
      );
    }

    // Filter categories by shop name
    categoriesByShopName = allCategories
        .where((category) => category.shopName == event.shopName)
        .toList();

    for (var category in categoriesByShopName) {}

    emit(CategoriesByShopNameSuccess(categories: categoriesByShopName));
  }
}
