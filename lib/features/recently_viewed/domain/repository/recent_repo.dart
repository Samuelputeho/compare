import 'package:compareitr/core/common/entities/recently_viewed_entity.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class RecentRepository {
  Future<Either<Failure, RecentlyViewedEntity>> addRecentItem({
    required String name,
    required String image,
    required String measure,
    required String shopName,
    required String recentId,
    required double price,
  });

  Future<Either<Failure, void>> removeRecentlyItem(String id);

  Future<Either<Failure, List<RecentlyViewedEntity>>> getRecentItems(
    String recentId,
  );
}
