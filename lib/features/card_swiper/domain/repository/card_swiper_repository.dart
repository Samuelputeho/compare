import 'package:fpdart/fpdart.dart';
import 'package:compareitr/core/common/models/card_swiper_pictures_model.dart';
import '../../../../core/error/failures.dart';

abstract interface class CardSwiperRepository {
  Future<Either<Failure, List<CardSwiperPicturesModel>>> getAllPictures();
}
