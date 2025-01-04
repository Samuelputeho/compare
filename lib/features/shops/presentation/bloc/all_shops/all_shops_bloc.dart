import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/entities/shop_entity.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecase/get_all_shops.dart';

part 'all_shops_event.dart';
part 'all_shops_state.dart';

class AllShopsBloc extends Bloc<AllShopsEvent, AllShopsState> {
  final GetAllShopsUsecase _getAllShopsUsecase;

  static List<ShopEntity> allStores = [];

  AllShopsBloc({required GetAllShopsUsecase getAllShopsUsecase})
      : _getAllShopsUsecase = getAllShopsUsecase,
        super(AllShopsInitial()) {
    on<AllShopsEvent>((event, emit) {});
    on<GetAllShopsEvent>(_onGetAllShops);
  }

  void _onGetAllShops(
    GetAllShopsEvent event,
    Emitter<AllShopsState> emit,
  ) async {
    emit(AllShopsLoading(loadingShops: allStores));
    final res = await _getAllShopsUsecase(NoParams());

    res.fold(
      (l) => emit(AllShopsFailure(message: l.message)),
      (r) {
        allStores = r;
        emit(AllShopsSuccess(shops: r));
      },
    );
  }
}
