import 'package:compareitr/core/common/entities/recently_viewed_entity.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/recently_viewed/domain/repository/recent_repo.dart';
import 'package:fpdart/fpdart.dart';

class GetRecentItemsUsecase
    implements UseCase<List<RecentlyViewedEntity>, String> {
  final RecentRepository recentRepository;

  const GetRecentItemsUsecase(this.recentRepository);

  @override
  Future<Either<Failure, List<RecentlyViewedEntity>>> call(
      String recentId) async {
    return await recentRepository.getRecentItems(recentId);
  }
}
