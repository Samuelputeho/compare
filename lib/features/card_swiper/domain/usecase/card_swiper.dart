import 'package:compareitr/core/common/entities/card_swiper_pictures_entinty.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/card_swiper_repository.dart';

class GetAllCardSwiperPicturesUseCase
    implements UseCase<List<CardSwiperPicturesEntinty>, NoParams> {
  final CardSwiperRepository repository;

  GetAllCardSwiperPicturesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CardSwiperPicturesEntinty>>> call(
      NoParams params) async {
    return repository.getAllPictures();
  }
}
