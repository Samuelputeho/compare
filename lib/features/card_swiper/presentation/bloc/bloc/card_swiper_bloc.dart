import 'package:compareitr/core/common/cache/cache.dart';
import 'package:compareitr/core/common/entities/card_swiper_pictures_entinty.dart';
import 'package:compareitr/features/card_swiper/domain/usecase/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';

part 'card_swiper_event.dart';
part 'card_swiper_state.dart';

class CardSwiperBloc extends Bloc<CardSwiperEvent, CardSwiperState> {
  final GetAllCardSwiperPicturesUseCase _getAllCardSwiperPicturesUseCase;

  // Static list for in-memory cache of the swiper pictures
  static List<CardSwiperPicturesEntinty> allPictures = [];

  CardSwiperBloc({required GetAllCardSwiperPicturesUseCase getAllCardSwiperPicturesUseCase})
      : _getAllCardSwiperPicturesUseCase = getAllCardSwiperPicturesUseCase,
        super(CardSwiperInitial()) {
    on<CardSwiperEvent>((event, emit) {}); // You can handle any other events here if needed
    on<GetAllCardSwiperPicturesEvent>(_onGetAllCardSwiperPictures);
  }

  void _onGetAllCardSwiperPictures(
    GetAllCardSwiperPicturesEvent event,
    Emitter<CardSwiperState> emit,
  ) async {
    // Check if the pictures are already cached
    var cachedPictures = CacheManager.getCache('cardSwiperPictures');

    if (cachedPictures != null && cachedPictures.isNotEmpty) {
      // If the pictures are cached, emit them immediately
      emit(CardSwiperSuccess(pictures: cachedPictures));
    } else {
      // If not cached, fetch from the API
      emit(CardSwiperLoading(loadingPictures: allPictures));

      final res = await _getAllCardSwiperPicturesUseCase(NoParams());

      res.fold(
        (failure) => emit(CardSwiperFailure(message: failure.message)),
        (pictures) {
          // Cache the pictures after successful API response
          CacheManager.cache('cardSwiperPictures', pictures);
          allPictures = pictures;
          emit(CardSwiperSuccess(pictures: pictures));
        },
      );
    }
  }
}
