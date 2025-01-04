part of 'card_swiper_bloc.dart';

@immutable
sealed class CardSwiperState {}

final class CardSwiperInitial extends CardSwiperState {}

final class CardSwiperLoading extends CardSwiperState {
  final List<CardSwiperPicturesEntinty> loadingPictures;
  CardSwiperLoading({required this.loadingPictures});
}

final class CardSwiperSuccess extends CardSwiperState {
  final List<CardSwiperPicturesEntinty> pictures;

  CardSwiperSuccess({required this.pictures});
}

final class CardSwiperFailure extends CardSwiperState {
  final String message;

  CardSwiperFailure({required this.message});
}
