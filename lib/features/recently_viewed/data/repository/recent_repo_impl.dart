import 'package:compareitr/core/common/entities/recently_viewed_entity.dart';
import 'package:compareitr/core/common/models/recently_viewed_model.dart';
import 'package:compareitr/core/error/exceptions.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/features/recently_viewed/data/datasource/recently_viewed_local_datasource.dart';
import 'package:compareitr/features/recently_viewed/data/datasource/recently_viewed_remote_data_source.dart';
import 'package:compareitr/core/common/network/network_connection.dart'; // For connection check
import 'package:compareitr/features/recently_viewed/domain/repository/recent_repo.dart';
import 'package:compareitr/features/sales/presentation/bloc/salecard_bloc.dart';
import 'package:fpdart/fpdart.dart'; // Functional programming support
import 'package:uuid/uuid.dart'; // For generating temporary UUIDs

class RecentRepoImpl implements RecentRepository {
  final RecentlyViewedRemoteDataSource remoteDataSource;

  RecentRepoImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, RecentlyViewedEntity>> addRecentItem({
    required String name,
    required String image,
    required String measure,
    required String shopName,
    required String recentId,
    required double price,
  }) async {
    try {
      final recentlyViewedModel = RecentlyViewedModel(
        id: const Uuid().v4(), // Generate a temporary ID if offline (this will not be used)
        name: name,
        image: image,
        measure: measure,
        shopName: shopName,
        recentId: recentId,
        price: price,
      );

      // Add item to remote data source (no internet check)
      await remoteDataSource.addRecentItem(
        name: name,
        image: image,
        measure: measure,
        shopName: shopName,
        recentId: recentId,
        price: price,
      );

      return right(RecentlyViewedEntity(
        id: recentlyViewedModel.id, // Using the generated ID
        name: name,
        image: image,
        measure: measure,
        shopName: shopName,
        recentId: recentId,
        price: price,
      ));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeRecentlyItem(String id) async {
    try {
      // Remove item from remote data source (no internet check)
      await remoteDataSource.removeRecentlyItem(id);

      return right(null); // Void return for success
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RecentlyViewedEntity>>> getRecentItems(String recentId) async {
    try {
      // Fetch items from the remote data source (no internet check)
      final recentModels = await remoteDataSource.getRecentItems(recentId);

      final recentEntities = recentModels.map((model) {
        return RecentlyViewedEntity(
          id: model.id,
          name: model.name,
          image: model.image,
          measure: model.measure,
          shopName: model.shopName,
          recentId: model.recentId,
          price: model.price,
        );
      }).toList();

      return right(recentEntities); // Return list of entities from remote
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error: $e'));
    }
  }
}
