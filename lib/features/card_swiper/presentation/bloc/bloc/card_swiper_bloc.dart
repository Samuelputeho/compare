import 'package:compareitr/core/common/entities/card_swiper_pictures_entinty.dart';
import 'package:compareitr/features/card_swiper/domain/usecase/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';

part 'card_swiper_event.dart';
part 'card_swiper_state.dart';

class CardSwiperBloc extends Bloc<CardSwiperEvent, CardSwiperState> {
  final GetAllCardSwiperPicturesUseCase _getAllCardSwiperPicturesUseCase;

  static List<CardSwiperPicturesEntinty> allPictures = [];

  CardSwiperBloc(
      {required GetAllCardSwiperPicturesUseCase
          getAllCardSwiperPicturesUseCase})
      : _getAllCardSwiperPicturesUseCase = getAllCardSwiperPicturesUseCase,
        super(CardSwiperInitial()) {
    on<CardSwiperEvent>((event, emit) {});
    on<GetAllCardSwiperPicturesEvent>(_onGetAllCardSwiperPictures);
  }

  void _onGetAllCardSwiperPictures(
    GetAllCardSwiperPicturesEvent event,
    Emitter<CardSwiperState> emit,
  ) async {
    emit(CardSwiperLoading(loadingPictures: allPictures));
    final res = await _getAllCardSwiperPicturesUseCase(NoParams());

    res.fold(
      (l) => emit(CardSwiperFailure(message: l.message)),
      (r) {
        allPictures = r;
        emit(CardSwiperSuccess(pictures: r));
      },
    );
  }
}
