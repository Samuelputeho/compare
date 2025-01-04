import 'package:compareitr/core/common/entities/recently_viewed_entity.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/recently_viewed/domain/repository/recent_repo.dart';
import 'package:fpdart/fpdart.dart';

class AddRecentItemUsecase
    implements UseCase<RecentlyViewedEntity, AddRecentItemParams> {
  final RecentRepository recentRepository;

  const AddRecentItemUsecase(this.recentRepository);

  @override
  Future<Either<Failure, RecentlyViewedEntity>> call(
      AddRecentItemParams params) async {
    return await recentRepository.addRecentItem(
      name: params.name,
      image: params.image,
      measure: params.measure,
      shopName: params.shopName,
      recentId: params.recentId,
      price: params.price,
    );
  }
}

class AddRecentItemParams {
  final String name;
  final String image;
  final String measure;
  final String shopName;
  final String recentId;
  final double price;

  AddRecentItemParams({
    required this.name,
    required this.image,
    required this.measure,
    required this.shopName,
    required this.recentId,
    required this.price,
  });
}
