import 'package:compareitr/core/common/models/card_swiper_pictures_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import 'package:compareitr/features/card_swiper/data/datasources/card_swiper_remote_data_source.dart';
import 'package:compareitr/features/card_swiper/domain/repository/card_swiper_repository.dart';

class CardSwiperRepositoryImpl implements CardSwiperRepository {
  final CardSwiperRemoteDataSource remoteDataSource;

  CardSwiperRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CardSwiperPicturesModel>>>
      getAllPictures() async {
    try {
      final pictures = await remoteDataSource.getAllPictures();
      return right(pictures);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
