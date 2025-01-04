import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/sales/domain/entity/sale_products_entity.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/features/sales/domain/usecases/get_all_sale_products_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'saleproducts_event.dart';
part 'saleproducts_state.dart';

class SaleProductBloc extends Bloc<SaleproductsEvent, SaleproductsState> {
  final GetAllSaleProductsUsecase getAllProductsUseCase;

  SaleProductBloc({required this.getAllProductsUseCase})
      : super(SaleproductsInitial()) {
    on<GetAllSaleProductsEvent>(_onGetAllSaleProductEvent);
  }

  Future<void> _onGetAllSaleProductEvent(
      SaleproductsEvent event, Emitter<SaleproductsState> emit) async {
    emit(SaleproductsLoading());
    final result = await getAllProductsUseCase(NoParams());

    result.fold(
      (failure) =>
          emit(SaleproductsFailure(message: _mapFailureToMessage(failure))),
      (saleProducts) => emit(SaleproductsSuccess(saleProducts: saleProducts)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    // Map the Failure to a user-friendly error message
    if (failure is ServerFailure) {
      return 'Server error occurred. Please try again later.';
    } else if (failure is NetworkFailure) {
      return 'Please check your internet connection.';
    } else {
      return 'An unexpected error occurred.';
    }
  }
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}
