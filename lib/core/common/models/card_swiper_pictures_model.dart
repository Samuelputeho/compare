import 'package:compareitr/core/common/entities/card_swiper_pictures_entinty.dart';

class CardSwiperPicturesModel extends CardSwiperPicturesEntinty {
  CardSwiperPicturesModel({
    required super.image,
  });
  factory CardSwiperPicturesModel.fromJson(Map<String, dynamic> json) {
    return CardSwiperPicturesModel(
      image: json['image'] as String? ?? '',
    );
  }
}
