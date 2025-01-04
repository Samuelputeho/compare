import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/sales/domain/entity/sale_card_entity.dart';
import 'package:compareitr/features/sales/domain/usecases/get_all_sale_card_usecase.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'salecard_event.dart';
part 'salecard_state.dart';

class SalecardBloc extends Bloc<SalecardEvent, SalecardState> {
  final GetSaleCardAllUsecase getSaleCardAllUsecase;

  SalecardBloc({required this.getSaleCardAllUsecase}) : super(SalecardInitial()) {
    on<GetAllSaleCardEvent>(_onGetAllSaleCardEvent);
  }

  Future<void> _onGetAllSaleCardEvent(
      GetAllSaleCardEvent event, Emitter<SalecardState> emit) async {
    emit(SalecardLoading());
    final result = await getSaleCardAllUsecase(NoParams());

    result.fold(
      (failure) {
        emit(SalecardFailure(message: _mapFailureToMessage(failure)));
      },
      (saleCards) {
        // Debug the saleCards data
        debugPrint('SaleCards: $saleCards');
        emit(SalecardSuccess(saleCard: saleCards));
      },
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
